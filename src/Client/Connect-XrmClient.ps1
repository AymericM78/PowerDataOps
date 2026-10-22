<#
    .SYNOPSIS
    Connect to Microsoft Dataverse without manually composing a connection string.

    .DESCRIPTION
    Build a Dataverse connection string from explicit authentication parameters or from a URL-only interactive login scenario, then delegate the connection to New-XrmClient.
    With AccessToken or AccessTokenProvider, connect with an access token obtained elsewhere (Azure PowerShell, Azure CLI, MSAL, managed identity...), without connection string. A token the environment refuses (issued for another resource or tenant, revoked, account without access) fails the connection with the service's reason.

    .PARAMETER Url
    Dataverse environment URL.

    .PARAMETER UserName
    User login for OAuth username/password authentication or interactive login hint.

    .PARAMETER Password
    User password for OAuth username/password authentication.

    .PARAMETER ClientId
    Application or client ID.

    .PARAMETER ClientSecret
    Application client secret.

    .PARAMETER CertificateThumbprint
    Application certificate thumbprint.

    .PARAMETER RedirectUri
    OAuth redirect URI.

    .PARAMETER LoginPrompt
    OAuth login prompt behavior.

    .PARAMETER IsEncrypted
    Specify if password or secret are encrypted.

    .PARAMETER Quiet
    Do not display the connection message.

    .PARAMETER AccessToken
    Access token for the environment: a string, a SecureString, or an object with a Token or AccessToken property (result of Get-AzAccessToken, MSAL AuthenticationResult). It is not renewed: once it expires (about one hour after it was issued), every request fails with an error giving its expiry. Use AccessTokenProvider for a longer session.

    .PARAMETER AccessTokenProvider
    Script block that returns an access token (same forms as AccessToken). It receives the environment URL (https://contoso.crm.dynamics.com) as its first argument. It is called at connection, then again when the token expires within 5 minutes (exp claim of the token; a token without this claim is asked for every request), so the session can outlast a token. It runs on the PowerShell thread that connected only: a clone of the client (Invoke-XrmParallelRequests, Publish-XrmComponent -TimeoutInMinutes) uses the last token while it is valid, and fails once it has expired.

    .OUTPUTS
    Microsoft.PowerPlatform.Dataverse.Client.ServiceClient. Microsoft Dataverse connector.

    .EXAMPLE
    Connect-XrmClient -Url "https://contoso.crm.dynamics.com";

    .EXAMPLE
    Connect-XrmClient -Url "https://contoso.crm.dynamics.com" -ClientId "<app-id>" -ClientSecret "<secret>";

    .EXAMPLE
    $url = "https://contoso.crm.dynamics.com";
    Connect-XrmClient -Url $url -AccessToken (az account get-access-token --resource $url --query accessToken --output tsv);

    .EXAMPLE
    # Token renewed during the session (Az.Accounts)
    Connect-XrmClient -Url "https://contoso.crm.dynamics.com" -AccessTokenProvider { param($url) Get-AzAccessToken -ResourceUrl $url };

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
#>
function Connect-XrmClient {
    [CmdletBinding(DefaultParameterSetName = 'Interactive')]
    [OutputType('Microsoft.PowerPlatform.Dataverse.Client.ServiceClient')]
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'Interactive')]
        [Parameter(Mandatory = $true, ParameterSetName = 'UserPassword')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ClientSecret')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Certificate')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AccessToken')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AccessTokenProvider')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Url,

        [Parameter(Mandatory = $false, ParameterSetName = 'Interactive')]
        [Parameter(Mandatory = $true, ParameterSetName = 'UserPassword')]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName,

        [Parameter(Mandatory = $true, ParameterSetName = 'UserPassword')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Password,

        [Parameter(Mandatory = $false, ParameterSetName = 'Interactive')]
        [Parameter(Mandatory = $false, ParameterSetName = 'UserPassword')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ClientSecret')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Certificate')]
        [ValidateNotNullOrEmpty()]
        [Alias('AppId', 'ApplicationId')]
        [String]
        $ClientId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ClientSecret')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ClientSecret,

        [Parameter(Mandatory = $true, ParameterSetName = 'Certificate')]
        [ValidateNotNullOrEmpty()]
        [Alias('Thumbprint', 'CertThumbprint')]
        [String]
        $CertificateThumbprint,

        [Parameter(Mandatory = $false, ParameterSetName = 'Interactive')]
        [Parameter(Mandatory = $false, ParameterSetName = 'UserPassword')]
        [ValidateNotNullOrEmpty()]
        [String]
        $RedirectUri,

        [Parameter(Mandatory = $false, ParameterSetName = 'Interactive')]
        [Parameter(Mandatory = $false, ParameterSetName = 'UserPassword')]
        [ValidateSet('Auto', 'Always', 'RefreshSession', 'SelectAccount', 'Never')]
        [String]
        $LoginPrompt,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsEncrypted = $false,

        [Parameter(Mandatory = $false)]
        [switch]
        $Quiet = $false,

        [Parameter(Mandatory = $true, ParameterSetName = 'AccessToken')]
        [ValidateNotNull()]
        [Object]
        $AccessToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'AccessTokenProvider')]
        [ValidateNotNull()]
        [ScriptBlock]
        $AccessTokenProvider
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'AccessToken') {
            New-XrmClient -Url $Url -AccessToken $AccessToken -Quiet:$Quiet;
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'AccessTokenProvider') {
            New-XrmClient -Url $Url -AccessTokenProvider $AccessTokenProvider -Quiet:$Quiet;
        }
        else {
            $connectionString = New-XrmClientConnectionStringInternal -Url $Url -UserName $UserName -Password $Password -ClientId $ClientId -ClientSecret $ClientSecret -CertificateThumbprint $CertificateThumbprint -RedirectUri $RedirectUri -LoginPrompt $LoginPrompt;
            New-XrmClient -ConnectionString $connectionString -IsEncrypted $IsEncrypted -Quiet:$Quiet;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Connect-XrmClient -Alias *;