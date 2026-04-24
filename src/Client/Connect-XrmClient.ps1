<#
    .SYNOPSIS
    Connect to Microsoft Dataverse without manually composing a connection string.

    .DESCRIPTION
    Build a Dataverse connection string from explicit authentication parameters or from a URL-only interactive login scenario, then delegate the connection to New-XrmClient.

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

    .OUTPUTS
    Microsoft.PowerPlatform.Dataverse.Client.ServiceClient. Microsoft Dataverse connector.

    .EXAMPLE
    Connect-XrmClient -Url "https://contoso.crm.dynamics.com";

    .EXAMPLE
    Connect-XrmClient -Url "https://contoso.crm.dynamics.com" -ClientId "<app-id>" -ClientSecret "<secret>";

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
        $Quiet = $false
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $connectionString = New-XrmClientConnectionStringInternal -Url $Url -UserName $UserName -Password $Password -ClientId $ClientId -ClientSecret $ClientSecret -CertificateThumbprint $CertificateThumbprint -RedirectUri $RedirectUri -LoginPrompt $LoginPrompt;
        New-XrmClient -ConnectionString $connectionString -IsEncrypted $IsEncrypted -Quiet:$Quiet;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Connect-XrmClient -Alias *;