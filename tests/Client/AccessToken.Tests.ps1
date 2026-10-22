<#
    Integration Test: connection with an access token
    Connect-XrmClient / New-XrmClient -Url -AccessToken | -AccessTokenProvider: parameter checks, token forms (string, SecureString,
    object with Token), provider called on the connecting thread only and again near expiry, clone and parallel requests,
    token kept out of the verbose log.
    The token is borrowed from the test connection (ServiceClient.CurrentAccessToken); the global client and context are restored.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$url = "https://$($Global:XrmClient.ConnectedOrgUriActual.Host)";
$sourceClient = $Global:XrmClient;
$sourceContext = $Global:XrmContext;
$expectedUserId = Get-XrmWhoAmI -XrmClient $sourceClient;
$moduleScope = Get-Module PowerDataOps;

# Unsigned token whose only claim is exp: enough for the provider, refused by Dataverse
function New-TestJwt {
    param([DateTimeOffset]$ExpiresOn)
    $parts = @('{"alg":"none","typ":"JWT"}', ('{"exp":' + $ExpiresOn.ToUnixTimeSeconds() + '}')) | ForEach-Object {
        [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($_)).TrimEnd('=').Replace('+', '-').Replace('/', '_');
    };
    return "$($parts[0]).$($parts[1]).signature";
}

function Get-ErrorMessage {
    param([scriptblock]$ScriptBlock)
    try { & $ScriptBlock | Out-Null; return $null; } catch { return $_.Exception.Message; }
}

# ============================================================
# Parameters (nothing sent)
# ============================================================
Write-Section "Parameter checks";

$message = Get-ErrorMessage { New-XrmClient -Url $url -Quiet };
Assert-Test "New-XrmClient -Url alone: error pointing to the token parameters" { $message -like "*Url goes with AccessToken or AccessTokenProvider*" };
$message = Get-ErrorMessage { New-XrmClient -ConnectionString "Url=$url" -Url $url -AccessToken "x" -Quiet };
Assert-Test "ConnectionString with Url / AccessToken: error" { $message -like "*Use either ConnectionString*" };
$message = Get-ErrorMessage { New-XrmClient -Url $url -AccessToken "x" -AccessTokenProvider { "y" } -Quiet };
Assert-Test "AccessToken with AccessTokenProvider: error" { $message -like "*either AccessToken or AccessTokenProvider*" };
$message = Get-ErrorMessage { New-XrmClient -Url "contoso" -AccessToken "x" -Quiet };
Assert-Test "Relative Url: error" { $message -like "*not an absolute URL*" };

$stopWatch = [System.Diagnostics.Stopwatch]::StartNew();
$message = Get-ErrorMessage { Connect-XrmClient -Url $url -AccessToken (New-TestJwt -ExpiresOn ([DateTimeOffset]::UtcNow.AddMinutes(-5))) -Quiet };
$stopWatch.Stop();
Assert-Test "Expired token: error giving its expiry, before connecting ($($stopWatch.ElapsedMilliseconds) ms)" { $message -like "*access token expired at*" -and $stopWatch.Elapsed.TotalSeconds -lt 10 };
$message = Get-ErrorMessage { Connect-XrmClient -Url $url -AccessToken 42 -Quiet };
Assert-Test "Token of another type: error naming the accepted forms" { $message -like "*string, a SecureString, or an object with a Token or AccessToken property*System.Int32*" };
$message = Get-ErrorMessage { Connect-XrmClient -Url $url -AccessTokenProvider { throw "no Azure context" } -Quiet };
Assert-Test "Failing provider: its error, at connection" { $message -like "AccessTokenProvider failed: no Azure context*" };
$message = Get-ErrorMessage { Connect-XrmClient -Url $url -AccessTokenProvider { } -Quiet };
Assert-Test "Provider returning nothing: error" { $message -like "*nothing was given*" };
Assert-Test "Global client untouched by the failures" { [object]::ReferenceEquals($Global:XrmClient, $sourceClient) };

# ============================================================
# Token provider (local)
# ============================================================
Write-Section "Token provider: cache, renewal, threads";

$providerType = 'PowerDataOpsAccessTokenProvider' -as [type];
$calls = [System.Collections.Generic.List[string]]::new();
$hourToken = New-TestJwt -ExpiresOn ([DateTimeOffset]::UtcNow.AddHours(1));
$newProvider = { param($block) New-XrmAccessTokenProviderInternal -AccessTokenProvider $block };
$hourBlock = { param($resource) $calls.Add($resource); $hourToken }.GetNewClosure();
$provider = & $moduleScope $newProvider $hourBlock;
$first = $provider.GetToken("$url/XRMServices/2011/Organization.svc/web?SDKClientVersion=9.2");
$second = $provider.GetToken("$url/XRMServices/2011/Organization.svc/web?SDKClientVersion=9.2");
Assert-Test "Token valid for 1 hour: provider called once for two requests" { $calls.Count -eq 1 -and $first -eq $hourToken -and $second -eq $hourToken };
Assert-Test "Provider receives the environment URL ($($calls[0]))" { $calls[0] -eq $url };
Assert-Test "Expiry read from the exp claim" { [Math]::Abs(($provider.ExpiresOn - [DateTimeOffset]::UtcNow.AddHours(1)).TotalSeconds) -lt 5 };

$nearCalls = [System.Collections.Generic.List[string]]::new();
$nearToken = New-TestJwt -ExpiresOn ([DateTimeOffset]::UtcNow.AddMinutes(2));
$nearBlock = { $nearCalls.Add("x"); $nearToken }.GetNewClosure();
$nearProvider = & $moduleScope $newProvider $nearBlock;
$nearProvider.GetToken($url) | Out-Null;
$nearProvider.GetToken($url) | Out-Null;
Assert-Test "Token expiring within 5 minutes: provider called again" { $nearCalls.Count -eq 2 };

Assert-Test "Forms: SecureString" { $providerType::ConvertToToken((ConvertTo-SecureString $hourToken -AsPlainText -Force)) -eq $hourToken };
Assert-Test "Forms: object with Token (Get-AzAccessToken)" { $providerType::ConvertToToken([PSCustomObject]@{ Token = $hourToken; ExpiresOn = [DateTimeOffset]::UtcNow }) -eq $hourToken };
Assert-Test "Forms: object with AccessToken (MSAL)" { $providerType::ConvertToToken([PSCustomObject]@{ AccessToken = $hourToken }) -eq $hourToken };
Assert-Test "Token without exp claim: no expiry" { $null -eq $providerType::GetExpiration("opaque-token") };

if ($PSVersionTable.PSVersion.Major -ge 7) {
    # Another runspace (parallel worker): the script block does not run there, the last token is given while valid
    $func = $provider.ToFunc();
    $parallelTokens = @($func, $func | ForEach-Object -Parallel { $_.Invoke("https://contoso.crm.dynamics.com").GetAwaiter().GetResult() });
    Assert-Test "Other runspace: last token, provider not called" { $parallelTokens.Count -eq 2 -and ($parallelTokens | Where-Object { $_ -ne $hourToken }).Count -eq 0 -and $calls.Count -eq 1 };

    $expiredProvider = & $moduleScope $newProvider { New-TestJwt -ExpiresOn ([DateTimeOffset]::UtcNow.AddMinutes(-1)) };
    $expiredProvider.GetToken($url) | Out-Null;
    $expiredFunc = $expiredProvider.ToFunc();
    $parallelError = $expiredFunc | ForEach-Object -Parallel { try { $_.Invoke("https://contoso.crm.dynamics.com").GetAwaiter().GetResult() } catch { $_.Exception.GetBaseException().Message } };
    Assert-Test "Other runspace, token expired: explicit error" { $parallelError -like "*expired*cannot run*" };
}
else {
    Write-Host "  [SKIP] ForEach-Object -Parallel needs PowerShell 7" -ForegroundColor Yellow;
}

# ============================================================
# Connections (restored at the end)
# ============================================================
try {
    Write-Section "Connect-XrmClient -AccessToken";

    $token = $sourceClient.CurrentAccessToken;
    $tokenExpiresOn = $providerType::GetExpiration($token);
    Write-Host "  Borrowed token expires at $tokenExpiresOn" -ForegroundColor DarkGray;

    $tokenClient = Connect-XrmClient -Url $url -AccessToken $token -Quiet;
    Assert-Test "Connected, external token management" { $tokenClient.IsReady -and $tokenClient.ActiveAuthenticationType -eq [Microsoft.PowerPlatform.Dataverse.Client.AuthenticationType]::ExternalTokenManagement };
    Assert-Test "Stored as the current client" { [object]::ReferenceEquals($Global:XrmClient, $tokenClient) -and $Global:XrmContext.IsUserConnected };
    Assert-Test "Same user as the source connection" { (Get-XrmWhoAmI -XrmClient $tokenClient) -eq $expectedUserId };
    $accounts = Get-XrmMultipleRecords -XrmClient $tokenClient -Query (New-XrmQueryExpression -LogicalName "account" -Columns "name" -TopCount 1) -AsArray;
    Assert-Test "Module cmdlet through the token client" { $null -ne $accounts };
    $webApiWhoAmI = & $moduleScope { param($client) Invoke-XrmWebApiRequestInternal -XrmClient $client -Method GET -Path "WhoAmI" -AsJson } $tokenClient;
    Assert-Test "Web API through the token client" { $webApiWhoAmI.SelectToken("UserId").ToString() -eq $expectedUserId };
    $tokenClient.Dispose();

    $secureClient = New-XrmClient -Url $url -AccessToken (ConvertTo-SecureString $token -AsPlainText -Force) -Quiet;
    Assert-Test "New-XrmClient -AccessToken <SecureString>" { $secureClient.IsReady -and (Get-XrmWhoAmI -XrmClient $secureClient) -eq $expectedUserId };
    $secureClient.Dispose();

    $objectClient = Connect-XrmClient -Url $url -AccessToken ([PSCustomObject]@{ Token = $token; ExpiresOn = $tokenExpiresOn }) -Quiet;
    Assert-Test "Connect-XrmClient -AccessToken <object with Token>" { $objectClient.IsReady };
    $objectClient.Dispose();

    $verboseOutput = Connect-XrmClient -Url $url -AccessToken $token -Quiet -Verbose 4>&1 | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] } | Out-String;
    Assert-Test "Token kept out of the verbose output" { -not $verboseOutput.Contains($token) -and $verboseOutput.Contains("AccessToken => ***") };
    $Global:XrmClient.Dispose();

    Write-Section "Connect-XrmClient -AccessTokenProvider";

    $providerCalls = [System.Collections.Generic.List[string]]::new();
    $borrowToken = { param($resource) $providerCalls.Add($resource); $sourceClient.CurrentAccessToken }.GetNewClosure();
    $providerClient = Connect-XrmClient -Url $url -AccessTokenProvider $borrowToken -Quiet;
    Assert-Test "Connected with a provider" { $providerClient.IsReady -and $providerClient.ActiveAuthenticationType -eq [Microsoft.PowerPlatform.Dataverse.Client.AuthenticationType]::ExternalTokenManagement };
    Assert-Test "Provider called with the environment URL ($($providerCalls[0]))" { $providerCalls.Count -ge 1 -and $providerCalls[0] -eq $url };
    $callsBefore = $providerCalls.Count;
    1..3 | ForEach-Object { Get-XrmWhoAmI -XrmClient $providerClient | Out-Null; };
    if ($tokenExpiresOn -and $tokenExpiresOn -gt [DateTimeOffset]::UtcNow.AddMinutes(10)) {
        Assert-Test "Three requests, token still valid: provider not called again" { $providerCalls.Count -eq $callsBefore };
    }
    else {
        Write-Host "  [SKIP] Borrowed token expires within 10 minutes: cache not asserted" -ForegroundColor Yellow;
    }

    # A clone asks for its token from a thread pool thread, where a script block converted to a delegate fails
    $clone = $providerClient.Clone();
    Assert-Test "Clone of a provider client: ready and usable" { $clone.IsReady -and (Get-XrmWhoAmI -XrmClient $clone) -eq $expectedUserId };
    $clone.Dispose();

    $whoAmIRequests = 1..6 | ForEach-Object { New-XrmRequest -Name "WhoAmI" };
    $parallelFaults = @(Invoke-XrmParallelRequests -XrmClient $providerClient -Requests $whoAmIRequests -BatchSize 2 -ThreadCount 3 -Quiet);
    Assert-Test "Invoke-XrmParallelRequests with a provider client: no fault ($($parallelFaults.Count))" { $parallelFaults.Count -eq 0 };
    $providerClient.Dispose();
}
finally {
    $Global:XrmClient = $sourceClient;
    $Global:XrmContext = $sourceContext;
}
Assert-Test "Global client and context restored" { [object]::ReferenceEquals($Global:XrmClient, $sourceClient) -and $Global:XrmClient.IsReady };

Write-TestSummary;
