<#
    .SYNOPSIS
    Initialize CrmserviceClient instance.
#>
function New-XrmClient {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Tooling.Connector.CrmServiceClient")]
    param
    (
        # https://docs.microsoft.com/fr-fr/powerapps/developer/common-data-service/xrm-tooling/use-connection-strings-xrm-tooling-connect
        [Parameter(Mandatory = $true)]
        [String]
        $ConnectionString,

        [Parameter(Mandatory = $false)]
        [int]
        $MaxCrmConnectionTimeOutMinutes = 2
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
	
        # Initialize CRM Client	
        $XrmClient = Get-CrmConnection -ConnectionString $ConnectionString -MaxCrmConnectionTimeOutMinutes $MaxCrmConnectionTimeOutMinutes -ErrorAction Stop;
	
        if ($XrmClient.IsReady -eq $false) {
            throw $XrmClient.LastCrmError;
        }

        $Global:XrmClient = $XrmClient;

        $url = $XrmClient.ConnectedOrgPublishedEndpoints["WebApplication"];
        $userId = $XrmClient.GetMyCrmUserId();
        # Store current settings to context as connection could be initiated with a simple connectionstring and we need thoose parameters for admin operations
        $userName = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "Username";
        if(-not $userName)
        {
            $userName = $userId;
        }
        
        Write-HostAndLog -Message "Connected to $($XrmClient.ConnectedOrgFriendlyName)! [Url = $url | User : $userName]" -ForegroundColor Yellow;        
        $XrmClient;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmClient -Alias *;