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

        $Global:XrmContext = New-XrmContext; 

        # Initialize CRM Client	
        if ($PSBoundParameters.ContainsKey('ConnectionString')) {

            if ($IsEncrypted) {
                $ConnectionString = Repair-XrbConnectionString -ConnectionString $ConnectionString;
            }

            $authType = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "AuthType";
            if ($authType -eq "Office365") {
                
                # Override O365
                $ConnectionString = $ConnectionString.Replace("Office365", "OAuth");
                $ConnectionString = "$ConnectionString;AppId=51f81489-12ee-4a9e-aaae-a2591f45987d; RedirectUri=app://58145B91-0C36-4500-8554-080854F2AC97;LoginPrompt=Auto;";

                # Warn about Office365 authentication
                if (-not $Quiet) {
                    Write-HostAndLog -Message "============================================================================" -Level WARN;
                    Write-HostAndLog -Message "/!\ Office365 authentication type is deprecated!" -Level WARN;
                    Write-HostAndLog -Message "Connection string as been modified to force OAuth protocol"  -Level WARN;
                    Write-HostAndLog -Message "============================================================================" -Level WARN;
                }
            }

            $XrmClient = [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]::new($ConnectionString);            
            $Global:XrmContext.CurrentConnection = New-XrmConnection -ConnectionString $ConnectionString;
            $Global:XrmContext.CurrentConnection.TenantId = $XrmClient.TenantId;
            Connect-XrmAdmin;
        }
        else {
            $XrmClient = Get-CrmConnection -InteractiveMode;
            $Global:XrmContext.CurrentConnection.TenantId = $XrmClient.TenantId;
            Connect-XrmAdmin;
        }
        if (-not $XrmClient.IsReady) {
            $Global:XrmContext.IsUserConnected = $false;
            throw $XrmClient.LastCrmError;
        }

        $Global:XrmClient = $XrmClient;
        $Global:XrmContext.IsUserConnected = $true;

        $Global:XrmContext.CurrentInstance = $XrmClient.OrganizationDetail;
        $Global:XrmContext.CurrentConnection.Name = $XrmClient.OrganizationDetail.UrlName;
        $Global:XrmContext.CurrentConnection.Region = $XrmClient.OrganizationDetail.Geo;

        $url = $XrmClient.ConnectedOrgPublishedEndpoints["WebApplication"];
        $Global:XrmContext.CurrentUrl = $url;

        $Global:XrmContext.IsOnline = $url.Contains('dynamics.com');        
        $Global:XrmContext.IsOnPremise = -not $Global:XrmContext.IsOnline;

        $userId = $XrmClient.GetMyCrmUserId();
        $Global:XrmContext.UserId = $userId;

        # Store current settings to context as connection could be initiated with a simple connectionstring and we need thoose parameters for admin operations
        if ($PSBoundParameters.ContainsKey('ConnectionString')) {
            $userName = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "Username";
        }
        if (-not $userName) {
            $userName = $userId;
        }
        
        if (-not $Quiet) {
            Write-HostAndLog -Message "Connected to $($XrmClient.ConnectedOrgFriendlyName)! [Url = $url | User : $userName]" -ForegroundColor Yellow; 
        }
        $XrmClient;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmClient -Alias *;