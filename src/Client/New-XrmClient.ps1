. ([System.IO.Path]::Combine($PSScriptRoot, "..", "_Internals", "CryptoManager.ps1"));

<#
    .SYNOPSIS
    Initialize CrmServiceClient instance. 
    
    .Description
    Create a new connection to Microsoft Dataverse with a connectionstring.
    An OAuth connection without password, secret or certificate signs in interactively. In a session that cannot show a sign-in prompt (started with -NonInteractive, no user desktop, remote session), it fails at once instead of waiting until the timeout, unless the connection string holds LoginPrompt=Never (silent sign-in only).
    With Url and AccessToken or AccessTokenProvider, the connection uses an access token obtained elsewhere (Azure PowerShell, Azure CLI, MSAL, managed identity...): the module does not sign in. A token the environment refuses (issued for another resource or tenant, revoked, account without access) fails the connection with the service's reason.

    .PARAMETER ConnectionString
    Connection String to Microsoft Dataverse instance (https://docs.microsoft.com/fr-fr/powerapps/developer/common-data-service/xrm-tooling/use-connection-strings-xrm-tooling-connect)
    
    .PARAMETER MaxCrmConnectionTimeOutMinutes
    Specify timeout duration in minutes.

    .PARAMETER IsEncrypted
    Specify if password or secret are encrypted.

    .PARAMETER Quiet
    Do not display the connection message.

    .PARAMETER ConfigPath
    Configuration file holding the connection string, in the standard .NET format (connectionStrings.config, app.config...), with ConnectionName, instead of ConnectionString. See Get-XrmConnectionString.

    .PARAMETER ConnectionName
    Name of the connection string entry in ConfigPath.

    .PARAMETER Url
    Environment URL (https://contoso.crm.dynamics.com), with AccessToken or AccessTokenProvider instead of ConnectionString.

    .PARAMETER AccessToken
    Access token for the environment, with Url: a string, a SecureString, or an object with a Token or AccessToken property (result of Get-AzAccessToken, MSAL AuthenticationResult). It is not renewed: once it expires (about one hour after it was issued), every request fails with an error giving its expiry. Use AccessTokenProvider for a longer session.

    .PARAMETER AccessTokenProvider
    Script block that returns an access token (same forms as AccessToken), with Url. It receives the environment URL (https://contoso.crm.dynamics.com) as its first argument. It is called at connection, then again when the token expires within 5 minutes (exp claim of the token; a token without this claim is asked for every request), so the session can outlast a token. It runs on the PowerShell thread that connected only: a clone of the client (Invoke-XrmParallelRequests, Publish-XrmComponent -TimeoutInMinutes) uses the last token while it is valid, and fails once it has expired.

    .OUTPUTS
    Microsoft.PowerPlatform.Dataverse.Client.ServiceClient. Microsoft Dataverse connector.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;

    .EXAMPLE
    $xrmClient = New-XrmClient -ConfigPath ".\connectionStrings.config" -ConnectionName "Dev";

    .EXAMPLE
    $xrmClient = New-XrmClient -Url "https://contoso.crm.dynamics.com" -AccessTokenProvider { param($url) Get-AzAccessToken -ResourceUrl $url };

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
#>
function New-XrmClient {
    [CmdletBinding()]
    [OutputType("Microsoft.PowerPlatform.Dataverse.Client.ServiceClient")]
    param
    (        
        [Parameter(Mandatory = $false)]
        [String]
        [ValidateNotNullOrEmpty()]
        $ConnectionString,

        [Parameter(Mandatory = $false)]
        [int]
        $MaxCrmConnectionTimeOutMinutes = 2,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsEncrypted = $false,

        [Parameter(Mandatory = $false)]
        [switch]
        $Quiet = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigPath,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConnectionName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Url,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Object]
        $AccessToken,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [ScriptBlock]
        $AccessTokenProvider
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $byAccessToken = $PSBoundParameters.ContainsKey('AccessToken') -or $PSBoundParameters.ContainsKey('AccessTokenProvider');
        if ($byAccessToken -or $PSBoundParameters.ContainsKey('Url')) {
            if ($PSBoundParameters.ContainsKey('ConnectionString') -or $PSBoundParameters.ContainsKey('ConfigPath') -or $PSBoundParameters.ContainsKey('ConnectionName')) {
                throw "Use either ConnectionString (or ConfigPath with ConnectionName), or Url with AccessToken or AccessTokenProvider.";
            }
            if (-not ($byAccessToken -and $PSBoundParameters.ContainsKey('Url'))) {
                throw "Url goes with AccessToken or AccessTokenProvider. To sign in interactively from a URL: Connect-XrmClient -Url.";
            }
            if ($PSBoundParameters.ContainsKey('AccessToken') -and $PSBoundParameters.ContainsKey('AccessTokenProvider')) {
                throw "Use either AccessToken or AccessTokenProvider.";
            }
        }

        if ($PSBoundParameters.ContainsKey('ConfigPath') -or $PSBoundParameters.ContainsKey('ConnectionName')) {
            if ($PSBoundParameters.ContainsKey('ConnectionString')) {
                throw "Use either ConnectionString or ConfigPath with ConnectionName.";
            }
            if (-not ($PSBoundParameters.ContainsKey('ConfigPath') -and $PSBoundParameters.ContainsKey('ConnectionName'))) {
                throw "ConfigPath and ConnectionName go together.";
            }
            $ConnectionString = Get-XrmConnectionString -ConfigPath $ConfigPath -Name $ConnectionName;
            $PSBoundParameters["ConnectionString"] = $ConnectionString;
        }

        # Optimizations
        [System.Net.ServicePointManager]::Expect100Continue = $false;
        [System.Net.ServicePointManager]::UseNagleAlgorithm = $false;
        [System.Net.ServicePointManager]::DefaultConnectionLimit = 1000;
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

        #[Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]::MaxConnectionTimeout = [System.TimeSpan]::new(0, $MaxCrmConnectionTimeOutMinutes, 0);

        # Initialize CRM Client	
        if ($PSBoundParameters.ContainsKey('ConnectionString')) {
            $ConnectionString = Resolve-XrmClientConnectionStringInternal -ConnectionString $ConnectionString -IsEncrypted $IsEncrypted;

            # Nobody can answer a sign-in prompt here: fail now instead of waiting for the connection timeout
            if (Test-XrmConnectionStringPromptInternal -ConnectionString $ConnectionString) {
                $nonInteractiveReason = Get-XrmNonInteractiveReasonInternal;
                if ($nonInteractiveReason) {
                    throw "Interactive sign-in is not possible in this session ($nonInteractiveReason): the connection would wait for a sign-in prompt until its timeout. Connect with a client secret (Connect-XrmClient -ClientId -ClientSecret) or a certificate (-CertificateThumbprint), or run from an interactive terminal. LoginPrompt=Never in the connection string tries a silent sign-in only.";
                }
            }

            $StopWatchXrmClient = [System.Diagnostics.Stopwatch]::StartNew(); 
            Trace-XrmFunction -Name 'NewDataverseServiceClient' -Stage Start; 
            try {
                $XrmClient = [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]::new($ConnectionString); 
            }
            catch {
                if($Global:XrmContext){
                    $Global:XrmContext.IsUserConnected = $false;
                }
                $connectionFailure = Get-XrmClientFailureInternal -Exception $_.Exception;
                throw [System.Exception]::new($connectionFailure.Message, $connectionFailure.Exception);
            }
            $StopWatchXrmClient.Stop();
            Trace-XrmFunction -Name 'NewDataverseServiceClient' -Stage Stop -StopWatch $StopWatchXrmClient;
        }
        elseif ($byAccessToken) {
            $instanceUri = $null;
            if (-not [Uri]::TryCreate($Url, [UriKind]::Absolute, [ref]$instanceUri)) {
                throw "Url '$Url' is not an absolute URL (https://contoso.crm.dynamics.com).";
            }

            # The first token is asked here, on this thread: a failing provider or an expired token stops before connecting
            try {
                if ($PSBoundParameters.ContainsKey('AccessTokenProvider')) {
                    $tokenProvider = New-XrmAccessTokenProviderInternal -AccessTokenProvider $AccessTokenProvider;
                }
                else {
                    $tokenProvider = New-XrmAccessTokenProviderInternal -AccessToken $AccessToken;
                }
                $tokenProvider.GetToken($instanceUri.AbsoluteUri) | Out-Null;
            }
            catch {
                $tokenError = $(if ($_.Exception.InnerException) { $_.Exception.InnerException } else { $_.Exception });
                throw $tokenError;
            }

            $StopWatchXrmClient = [System.Diagnostics.Stopwatch]::StartNew();
            Trace-XrmFunction -Name 'NewDataverseServiceClient' -Stage Start;
            try {
                $XrmClient = [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]::new($instanceUri, $tokenProvider.ToFunc(), $true, $null);
            }
            catch {
                if($Global:XrmContext){
                    $Global:XrmContext.IsUserConnected = $false;
                }
                $connectionFailure = Get-XrmClientFailureInternal -Exception $_.Exception;
                throw [System.Exception]::new($connectionFailure.Message, $connectionFailure.Exception);
            }
            $StopWatchXrmClient.Stop();
            Trace-XrmFunction -Name 'NewDataverseServiceClient' -Stage Stop -StopWatch $StopWatchXrmClient;
        }
        else {
            throw "New-XrmClient requires ConnectionString (a URL-only one signs in interactively), ConfigPath with ConnectionName, or Url with AccessToken or AccessTokenProvider.";
        }

        if (-not $XrmClient.IsReady) {
            if($Global:XrmContext){
                $Global:XrmContext.IsUserConnected = $false;
            }
            $clientFailure = Get-XrmClientFailureInternal -Client $XrmClient;
            if ($null -ne $clientFailure.Exception) {
                throw [System.Exception]::new($clientFailure.Message, $clientFailure.Exception);
            }
            throw $clientFailure.Message;
        }

        # A token the environment refuses still gives a ready client, without the organization details read at connection:
        # one request gets the service's reason (New-XrmContext failed on the missing details with "Cannot index into a null array")
        if ($byAccessToken -and $null -eq $XrmClient.OrganizationDetail) {
            try {
                $null = Get-XrmWhoAmI -XrmClient $XrmClient -ErrorAction Stop;
            }
            catch {
                if ($Global:XrmContext) {
                    $Global:XrmContext.IsUserConnected = $false;
                }
                $refusal = $_.Exception;
                if ($refusal -is [System.Management.Automation.MethodInvocationException] -and $null -ne $refusal.InnerException) {
                    $refusal = $refusal.InnerException;
                }
                $hint = "";
                if ($refusal.Message -match "unauthorized") {
                    $hint = " Check that the token was issued for this environment (resource $($instanceUri.GetLeftPart([UriPartial]::Authority))), in its tenant, and has not been revoked.";
                }
                elseif ($refusal.Message -match "forbidden") {
                    $hint = " The token is valid but its account has no access to this environment: it must be a user (or application user) of it, with a security role.";
                }
                throw [System.Exception]::new("Dataverse refused the access token for '$($instanceUri.AbsoluteUri)': $($refusal.Message)$hint", $refusal);
            }
        }

        # Store new context
        # Only an admin connection already opened in this session is refreshed (the admin module is loaded on demand)
        $refreshAdminConnection = ($Global:XrmContext -and $Global:XrmContext.IsAdminConnected -and $XrmClient.TenantId -ne $Global:XrmContext.CurrentConnection.TenantId);
        if ($PSBoundParameters.ContainsKey('ConnectionString')) {
            $Global:XrmContext = New-XrmContext -XrmClient $XrmClient -ConnectionString $ConnectionString;
        } 
        else{
            $Global:XrmContext = New-XrmContext -XrmClient $XrmClient;
        }
        $Global:XrmContext.IsEncrypted = $IsEncrypted;

        # Store client to simplify commands execution
        $Global:XrmClient = $XrmClient;

        # Try to use admin commands         
        if($refreshAdminConnection){    
            Connect-XrmAdmin -ErrorAction SilentlyContinue;
        }

        if ($PSBoundParameters.ContainsKey('ConnectionString')) {
            $userName = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "Username";
        }
        if (-not $userName) {
            $userName = $XrmContext.UserId;
        }
        
        if (-not $Quiet) {
            Write-HostAndLog -Message "Connected to $($XrmClient.ConnectedOrgFriendlyName)! [Url = $($XrmContext.CurrentUrl) | User : $userName]" -ForegroundColor Yellow; 
        }
        $XrmClient;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmClient -Alias *;