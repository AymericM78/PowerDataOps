. "$PsScriptRoot\..\_Internals\CryptoManager.ps1"
<#
    .SYNOPSIS
    Initialize CrmServiceClient instance. 
    
    .Description
    Create a new connection to Microsoft Dataverse with a connectionstring.

    .PARAMETER ConnectionString
    Connection String to Microsoft Dataverse instance (https://docs.microsoft.com/fr-fr/powerapps/developer/common-data-service/xrm-tooling/use-connection-strings-xrm-tooling-connect)
    
    .PARAMETER MaxCrmConnectionTimeOutMinutes
    Specify timeout duration in minutes for connection.

    .OUTPUTS
    Microsoft.Xrm.Tooling.Connector.CrmServiceClient. Microsoft Dataverse connector.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
#>
function New-XrmClient {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Tooling.Connector.CrmServiceClient")]
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
        $IsEncrypted = $false
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
        if ($PSBoundParameters.ContainsKey('ConnectionString')) {

            if($IsEncrypted)
            {
                $ConnectionString = Repair-XrbConnectionString -ConnectionString $ConnectionString;
            }

            $XrmClient = Get-CrmConnection -ConnectionString $ConnectionString -MaxCrmConnectionTimeOutMinutes $MaxCrmConnectionTimeOutMinutes -ErrorAction Stop;

            # Warn about Office365 authentication
            $authType = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "AuthType";
            if($authType -eq "Office365")
            {
                Write-HostAndLog -Message "============================================================================" -Level WARN;
                Write-HostAndLog -Message "/!\ Office365 authentication type is deprecated!" -Level WARN;
                Write-HostAndLog -Message "More info: " -Level WARN;
                Write-HostAndLog -Message " - https://docs.microsoft.com/fr-fr/power-platform/important-changes-coming#deprecation-of-office365-authentication-type-and-organizationserviceproxy-class-for-connecting-to-dataverse" -Level WARN;
                Write-HostAndLog -Message "============================================================================" -Level WARN;
            }
        }
        else {
            $XrmClient = Get-CrmConnection -InteractiveMode;
        }
        if ($XrmClient.IsReady -eq $false) {
            throw $XrmClient.LastCrmError;
        }

        $Global:XrmClient = $XrmClient;

        $url = $XrmClient.ConnectedOrgPublishedEndpoints["WebApplication"];
        $userId = $XrmClient.GetMyCrmUserId();
        # Store current settings to context as connection could be initiated with a simple connectionstring and we need thoose parameters for admin operations
        if ($PSBoundParameters.ContainsKey('ConnectionString')) {
            $userName = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "Username";
        }
        if (-not $userName) {
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