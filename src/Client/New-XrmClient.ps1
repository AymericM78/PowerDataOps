. "$PsScriptRoot\..\_Internals\CryptoManager.ps1";

<#
    .SYNOPSIS
    Initialize CrmServiceClient instance. 
    
    .Description
    Create a new connection to Microsoft Dataverse with a connectionstring.

    .PARAMETER ConnectionString
    Connection String to Microsoft Dataverse instance (https://docs.microsoft.com/fr-fr/powerapps/developer/common-data-service/xrm-tooling/use-connection-strings-xrm-tooling-connect)
    
    .PARAMETER MaxCrmConnectionTimeOutMinutes
    Specify timeout duration in minutes.

    .PARAMETER IsEncrypted
    Specify if password or secret are encrypted.

    .OUTPUTS
    Microsoft.PowerPlatform.Dataverse.Client.ServiceClient. Microsoft Dataverse connector.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;

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
        $Quiet = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        # Optimizations
        [System.Net.ServicePointManager]::Expect100Continue = $false;
        [System.Net.ServicePointManager]::UseNagleAlgorithm = $false;
        [System.Net.ServicePointManager]::DefaultConnectionLimit = 1000;
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

        #[Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]::MaxConnectionTimeout = [System.TimeSpan]::new(0, $MaxCrmConnectionTimeOutMinutes, 0);

        # Initialize CRM Client	
        if ($PSBoundParameters.ContainsKey('ConnectionString')) {
            $ConnectionString = Resolve-XrmClientConnectionStringInternal -ConnectionString $ConnectionString -IsEncrypted $IsEncrypted;

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
        $refreshAdminConnection = ($Global:XrmContext -and $XrmClient.TenantId -ne $Global:XrmContext.CurrentConnection.TenantId);
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