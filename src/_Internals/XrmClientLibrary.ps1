function ConvertTo-XrmConnectionStringMapInternal {
    param(
        [string]
        $RawConnectionString
    );

    $parameters = [ordered]@{};
    if ([string]::IsNullOrWhiteSpace($RawConnectionString)) {
        return $parameters;
    }

    $RawConnectionString.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {
        $connectionStringSegment = $_.Trim();
        if (-not [string]::IsNullOrWhiteSpace($connectionStringSegment)) {
            $separatorIndex = $connectionStringSegment.IndexOf('=');
            if ($separatorIndex -gt 0) {
                $parameterName = $connectionStringSegment.Substring(0, $separatorIndex).Trim();
                $parameterValue = $connectionStringSegment.Substring($separatorIndex + 1).Trim();
                $normalizedParameterName = $parameterName.Replace(' ', '').ToLowerInvariant();
                if (-not [string]::IsNullOrWhiteSpace($normalizedParameterName)) {
                    $parameters[$normalizedParameterName] = [PSCustomObject]@{
                        Name = $parameterName;
                        Value = $parameterValue;
                    };
                }
            }
        }
    };

    return $parameters;
}


function Get-XrmConnectionStringValueInternal {
    param(
        [System.Collections.IDictionary]
        $Parameters,

        [string[]]
        $Names
    );

    foreach ($name in $Names) {
        $normalizedName = $name.Replace(' ', '').ToLowerInvariant();
        if ($Parameters.Contains($normalizedName)) {
            return [string]$Parameters[$normalizedName].Value;
        }
    }

    return $null;
}


function Set-XrmConnectionStringValueInternal {
    param(
        [System.Collections.IDictionary]
        $Parameters,

        [string]
        $Name,

        [string]
        $Value
    );

    $normalizedName = $Name.Replace(' ', '').ToLowerInvariant();
    if ($Parameters.Contains($normalizedName)) {
        $Parameters[$normalizedName].Name = $Name;
        $Parameters[$normalizedName].Value = $Value;
    }
    else {
        $Parameters[$normalizedName] = [PSCustomObject]@{
            Name = $Name;
            Value = $Value;
        };
    }
}


function ConvertFrom-XrmConnectionStringMapInternal {
    param(
        [System.Collections.IDictionary]
        $Parameters
    );

    $segments = @();
    foreach ($parameter in $Parameters.Values) {
        $segments += "$($parameter.Name)=$($parameter.Value)";
    }

    if ($segments.Count -eq 0) {
        return $null;
    }

    return (($segments -join ';') + ';');
}


function Get-XrmExceptionDetailsInternal {
    param(
        [System.Exception]
        $Exception
    );

    if ($null -eq $Exception) {
        return $null;
    }

    $messages = @();
    $currentException = $Exception;
    while ($null -ne $currentException) {
        $message = $currentException.Message;
        if (-not ($currentException.InnerException -and $message -like 'Exception calling*') -and -not [string]::IsNullOrWhiteSpace($message) -and $messages -notcontains $message) {
            $messages += $message;
        }
        $currentException = $currentException.InnerException;
    }

    return ($messages -join ' | ');
}


function Get-XrmClientFailureInternal {
    param(
        [Parameter(Mandatory = $false)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $Client,

        [Parameter(Mandatory = $false)]
        [System.Exception]
        $Exception
    );

    $lastError = $null;
    $lastException = $null;

    if ($null -ne $Client) {
        foreach ($propertyName in @('LastError', 'LastCrmError')) {
            $property = $Client.PSObject.Properties[$propertyName];
            if ($null -ne $property -and -not [string]::IsNullOrWhiteSpace([string]$property.Value)) {
                $lastError = [string]$property.Value;
                break;
            }
        }

        foreach ($propertyName in @('LastException', 'LastCrmException')) {
            $property = $Client.PSObject.Properties[$propertyName];
            if ($null -ne $property -and $null -ne $property.Value) {
                $lastException = $property.Value;
                break;
            }
        }
    }

    if ($null -ne $Exception -and $null -eq $lastException) {
        $lastException = $Exception;
    }

    $exceptionDetails = Get-XrmExceptionDetailsInternal -Exception $lastException;
    if (-not [string]::IsNullOrWhiteSpace($exceptionDetails)) {
        if (-not [string]::IsNullOrWhiteSpace($lastError) -and $exceptionDetails -notlike "*$lastError*") {
            $lastError = "$lastError | $exceptionDetails";
        }
        else {
            $lastError = $exceptionDetails;
        }
    }

    if ([string]::IsNullOrWhiteSpace($lastError)) {
        $lastError = 'Failed to connect to Dataverse.';
    }

    return [PSCustomObject]@{
        Message = $lastError;
        Exception = $lastException;
    };
}


function Resolve-XrmClientConnectionStringInternal {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ConnectionString,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsEncrypted = $false
    );

    if ($IsEncrypted) {
        $ConnectionString = Repair-XrbConnectionString -ConnectionString $ConnectionString;
    }

    $authType = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName 'AuthType';
    if ($authType -eq 'Office365') {
        $ConnectionString = $ConnectionString.Replace('Office365', 'OAuth');
        $authType = 'OAuth';
    }

    $connectionStringParameters = ConvertTo-XrmConnectionStringMapInternal -RawConnectionString $ConnectionString;
    $password = Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('Password');
    $clientSecret = Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('ClientSecret', 'Secret');
    $thumbprint = Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('Thumbprint', 'CertThumbprint');
    $serviceUrl = Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('Url', 'ServiceUri', 'Service Uri', 'Server');
    $hasExplicitCredentials = -not [string]::IsNullOrWhiteSpace($password) -or -not [string]::IsNullOrWhiteSpace($clientSecret) -or -not [string]::IsNullOrWhiteSpace($thumbprint);
    $shouldUseInteractiveFallback = $hasExplicitCredentials -eq $false -and ([string]::IsNullOrWhiteSpace($authType) -or $authType -eq 'OAuth');

    if ($shouldUseInteractiveFallback) {
        if ([string]::IsNullOrWhiteSpace($serviceUrl)) {
            throw 'New-XrmClient interactive authentication requires a connection string containing Url=<DataverseUrl>.';
        }

        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AuthType' -Value 'OAuth';

        if ([string]::IsNullOrWhiteSpace((Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('AppId', 'ClientId', 'ApplicationId')))) {
            Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AppId' -Value '51f81489-12ee-4a9e-aaae-a2591f45987d';
        }

        if ([string]::IsNullOrWhiteSpace((Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('RedirectUri', 'ReplyUrl')))) {
            Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'RedirectUri' -Value 'http://localhost';
        }

        if ([string]::IsNullOrWhiteSpace((Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('LoginPrompt')))) {
            Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'LoginPrompt' -Value 'Auto';
        }

        $ConnectionString = ConvertFrom-XrmConnectionStringMapInternal -Parameters $connectionStringParameters;
    }

    return $ConnectionString;
}


# True when a (resolved) connection string may show an OAuth sign-in prompt: OAuth without password, secret or certificate, and LoginPrompt other than Never
function Test-XrmConnectionStringPromptInternal {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ConnectionString
    );

    $connectionStringParameters = ConvertTo-XrmConnectionStringMapInternal -RawConnectionString $ConnectionString;
    $authType = Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('AuthType', 'AuthenticationType');
    if ($authType -ne 'OAuth') {
        return $false;
    }
    foreach ($credentialNames in @('Password'), @('ClientSecret', 'Secret'), @('Thumbprint', 'CertThumbprint')) {
        if (-not [string]::IsNullOrWhiteSpace((Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names $credentialNames))) {
            return $false;
        }
    }
    $loginPrompt = Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('LoginPrompt');
    return ($loginPrompt -ne 'Never');
}


# Why the session cannot answer an interactive sign-in, or $null when it can: no user desktop (service, pipeline agent),
# no graphical display on Linux, a remote session, or a host started with -NonInteractive. The parameters exist for the tests.
function Get-XrmNonInteractiveReasonInternal {
    param(
        [Parameter(Mandatory = $false)]
        [string[]]
        $CommandLineArgs = [Environment]::GetCommandLineArgs(),

        [Parameter(Mandatory = $false)]
        [bool]
        $UserInteractive = [Environment]::UserInteractive,

        [Parameter(Mandatory = $false)]
        [string]
        $HostName = $Host.Name,

        # Linux and other X11 / Wayland systems, where UserInteractive is always true: the sign-in opens a browser, which needs a graphical session
        [Parameter(Mandatory = $false)]
        [bool]
        $NeedsDisplay = ([Environment]::OSVersion.Platform -eq [PlatformID]::Unix -and -not [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX)),

        [Parameter(Mandatory = $false)]
        [string]
        $Display = "$env:DISPLAY$env:WAYLAND_DISPLAY"
    );

    if (-not $UserInteractive) {
        return 'the process has no interactive desktop';
    }
    if ($NeedsDisplay -and [string]::IsNullOrWhiteSpace($Display)) {
        return 'there is no graphical display for the sign-in browser (DISPLAY and WAYLAND_DISPLAY are not set)';
    }
    if ($HostName -eq 'ServerRemoteHost') {
        return 'it is a remote session';
    }
    # Host options come first; the script (-File, or a .ps1 path) or the command ends them, and what follows belongs to it
    foreach ($argument in @($CommandLineArgs | Select-Object -Skip 1)) {
        if ($argument -match '^(-|--|/)(f|file|c|command|e|ec|encodedcommand|cwa|commandwithargs)$' -or $argument -like '*.ps1') {
            break;
        }
        if ($argument -match '^(-|--|/)noni') {
            return 'PowerShell was started with -NonInteractive';
        }
    }
    return $null;
}


function New-XrmClientConnectionStringInternal {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Url,

        [Parameter(Mandatory = $false)]
        [string]
        $UserName,

        [Parameter(Mandatory = $false)]
        [string]
        $Password,

        [Parameter(Mandatory = $false)]
        [string]
        $ClientId,

        [Parameter(Mandatory = $false)]
        [string]
        $ClientSecret,

        [Parameter(Mandatory = $false)]
        [string]
        $CertificateThumbprint,

        [Parameter(Mandatory = $false)]
        [string]
        $RedirectUri,

        [Parameter(Mandatory = $false)]
        [string]
        $LoginPrompt
    );

    if ([string]::IsNullOrWhiteSpace($Url)) {
        throw 'Connect-XrmClient requires Url=<DataverseUrl>.';
    }

    $connectionStringParameters = [ordered]@{};
    Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'Url' -Value $Url;

    if (-not [string]::IsNullOrWhiteSpace($ClientSecret)) {
        if ([string]::IsNullOrWhiteSpace($ClientId)) {
            throw 'Connect-XrmClient client secret authentication requires -ClientId.';
        }

        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AuthType' -Value 'ClientSecret';
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'ClientId' -Value $ClientId;
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'ClientSecret' -Value $ClientSecret;

        return ConvertFrom-XrmConnectionStringMapInternal -Parameters $connectionStringParameters;
    }

    if (-not [string]::IsNullOrWhiteSpace($CertificateThumbprint)) {
        if ([string]::IsNullOrWhiteSpace($ClientId)) {
            throw 'Connect-XrmClient certificate authentication requires -ClientId.';
        }

        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AuthType' -Value 'Certificate';
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'ClientId' -Value $ClientId;
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'Thumbprint' -Value $CertificateThumbprint;

        return ConvertFrom-XrmConnectionStringMapInternal -Parameters $connectionStringParameters;
    }

    $hasUserName = -not [string]::IsNullOrWhiteSpace($UserName);
    $hasPassword = -not [string]::IsNullOrWhiteSpace($Password);

    if ($hasPassword -and -not $hasUserName) {
        throw 'Connect-XrmClient username/password authentication requires both -UserName and -Password.';
    }

    Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AuthType' -Value 'OAuth';

    if ($hasUserName) {
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'Username' -Value $UserName;
    }

    if ($hasPassword) {
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'Password' -Value $Password;
    }

    if ([string]::IsNullOrWhiteSpace($ClientId)) {
        $ClientId = '51f81489-12ee-4a9e-aaae-a2591f45987d';
    }
    if ([string]::IsNullOrWhiteSpace($RedirectUri)) {
        $RedirectUri = 'http://localhost';
    }
    if ([string]::IsNullOrWhiteSpace($LoginPrompt)) {
        $LoginPrompt = 'Auto';
    }

    Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AppId' -Value $ClientId;
    Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'RedirectUri' -Value $RedirectUri;
    Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'LoginPrompt' -Value $LoginPrompt;

    return ConvertFrom-XrmConnectionStringMapInternal -Parameters $connectionStringParameters;
}


# Token source of a connection by access token (New-XrmClient / Connect-XrmClient -AccessToken or -AccessTokenProvider).
# The ServiceClient asks for a token before every request, and from a thread pool thread in Clone and async calls, where a
# script block converted to a delegate fails ("There is no Runspace available to run scripts in this thread"). This class
# keeps the last token and runs the provider only on the thread of the runspace that connected, when the token expires
# within 5 minutes (exp claim); the other threads get the last token while it is valid. C# 5, for Windows PowerShell 5.1.
# Compiled on first use, not at module load.
function New-XrmAccessTokenProviderInternal {
    param(
        [Parameter(Mandatory = $false)]
        [object]
        $AccessToken,

        [Parameter(Mandatory = $false)]
        [scriptblock]
        $AccessTokenProvider
    );

    $providerType = 'PowerDataOpsAccessTokenProvider' -as [type];
    if (-not $providerType) {
        $source = @'
using System;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Net;
using System.Security;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

public class PowerDataOpsAccessTokenProvider
{
    private static readonly TimeSpan RefreshMargin = TimeSpan.FromMinutes(5);
    private readonly object sync = new object();
    private ScriptBlock provider;
    private Runspace runspace;
    private string token;
    private DateTimeOffset? expiresOn;

    public static PowerDataOpsAccessTokenProvider FromToken(object accessToken)
    {
        PowerDataOpsAccessTokenProvider tokenProvider = new PowerDataOpsAccessTokenProvider();
        tokenProvider.token = ConvertToToken(accessToken);
        tokenProvider.expiresOn = GetExpiration(tokenProvider.token);
        return tokenProvider;
    }

    public static PowerDataOpsAccessTokenProvider FromScriptBlock(ScriptBlock accessTokenProvider)
    {
        PowerDataOpsAccessTokenProvider tokenProvider = new PowerDataOpsAccessTokenProvider();
        tokenProvider.provider = accessTokenProvider;
        tokenProvider.runspace = Runspace.DefaultRunspace;
        return tokenProvider;
    }

    public DateTimeOffset? ExpiresOn { get { return expiresOn; } }

    public Func<string, Task<string>> ToFunc()
    {
        return new Func<string, Task<string>>(GetTokenAsync);
    }

    public Task<string> GetTokenAsync(string resource)
    {
        return Task.FromResult(GetToken(resource));
    }

    public string GetToken(string resource)
    {
        lock (sync)
        {
            DateTimeOffset now = DateTimeOffset.UtcNow;
            if (provider == null)
            {
                if (expiresOn.HasValue && expiresOn.Value <= now)
                {
                    throw new InvalidOperationException("The access token expired at " + expiresOn.Value.ToLocalTime().ToString("u") + ": connect again with a new token, or with -AccessTokenProvider to renew it during the session.");
                }
                return token;
            }
            if (token != null && expiresOn.HasValue && expiresOn.Value - now > RefreshMargin)
            {
                return token;
            }
            if (Runspace.DefaultRunspace == null || Runspace.DefaultRunspace != runspace)
            {
                if (token != null && (!expiresOn.HasValue || expiresOn.Value > now))
                {
                    return token;
                }
                throw new InvalidOperationException("The access token returned by AccessTokenProvider has expired, and the new one is asked from a thread where the script block cannot run (clone of the client, parallel requests). A request sent from PowerShell with the client renews it: split the parallel work that outlasts a token.");
            }

            string url = resource;
            Uri uri;
            if (Uri.TryCreate(resource, UriKind.Absolute, out uri))
            {
                url = uri.GetLeftPart(UriPartial.Authority);
            }
            Collection<PSObject> results;
            try
            {
                results = provider.Invoke(url);
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("AccessTokenProvider failed: " + ex.Message, ex);
            }
            object value = null;
            for (int i = results.Count - 1; i >= 0 && value == null; i--)
            {
                value = results[i];
            }
            token = ConvertToToken(value);
            expiresOn = GetExpiration(token);
            return token;
        }
    }

    public static string ConvertToToken(object value)
    {
        PSObject wrapper = value as PSObject;
        object baseObject = wrapper != null ? wrapper.BaseObject : value;
        string text = baseObject as string;
        SecureString secure = baseObject as SecureString;
        if (text != null && text.Trim().Length > 0)
        {
            return text.Trim();
        }
        if (secure != null && secure.Length > 0)
        {
            return new NetworkCredential(string.Empty, secure).Password;
        }
        if (baseObject != null && text == null && secure == null)
        {
            // Get-AzAccessToken result (Token), MSAL AuthenticationResult (AccessToken)
            PSObject members = wrapper ?? PSObject.AsPSObject(baseObject);
            foreach (string name in new string[] { "Token", "AccessToken" })
            {
                PSPropertyInfo property = members.Properties[name];
                if (property != null && property.Value != null)
                {
                    return ConvertToToken(property.Value);
                }
            }
        }
        string received = baseObject == null ? "nothing was given" : (text != null || secure != null ? "it is empty" : "received " + baseObject.GetType().FullName);
        throw new InvalidOperationException("An access token is a string, a SecureString, or an object with a Token or AccessToken property (Get-AzAccessToken, MSAL AuthenticationResult): " + received + ".");
    }

    public static DateTimeOffset? GetExpiration(string accessToken)
    {
        string[] parts = accessToken == null ? new string[0] : accessToken.Split('.');
        if (parts.Length != 3)
        {
            return null;
        }
        try
        {
            string payload = parts[1].Replace('-', '+').Replace('_', '/');
            payload = payload.PadRight(payload.Length + (4 - payload.Length % 4) % 4, '=');
            Match match = Regex.Match(Encoding.UTF8.GetString(Convert.FromBase64String(payload)), "\"exp\"\\s*:\\s*(\\d+)");
            if (!match.Success)
            {
                return null;
            }
            return DateTimeOffset.FromUnixTimeSeconds(long.Parse(match.Groups[1].Value));
        }
        catch (FormatException)
        {
            return null;
        }
    }
}
'@;
        $providerType = Add-Type -TypeDefinition $source -PassThru | Where-Object { $_.Name -eq 'PowerDataOpsAccessTokenProvider' };
    }

    if ($AccessTokenProvider) {
        return $providerType::FromScriptBlock($AccessTokenProvider);
    }
    return $providerType::FromToken($AccessToken);
}