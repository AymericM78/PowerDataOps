. "$PsScriptRoot\..\_Internals\CryptoManager.ps1";

<#
    .SYNOPSIS
    Initialize CrmServiceClient instance. 
    
    .Description
    Create a new connection to Microsoft Dataverse with a connectionstring.
    An OAuth connection without password, secret or certificate signs in interactively. In a session that cannot show a sign-in prompt (started with -NonInteractive, no user desktop, remote session), it fails at once instead of waiting until the timeout, unless the connection string holds LoginPrompt=Never (silent sign-in only).

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

    .OUTPUTS
    Microsoft.PowerPlatform.Dataverse.Client.ServiceClient. Microsoft Dataverse connector.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;

    .EXAMPLE
    $xrmClient = New-XrmClient -ConfigPath ".\connectionStrings.config" -ConnectionName "Dev";

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
        $ConnectionName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
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
        else {
            throw "New-XrmClient interactive authentication requires a connection string containing Url=<DataverseUrl>.";
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