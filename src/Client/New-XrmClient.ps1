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
        }
        else {
            # Interactive login => use legacy PowerShell connector
            $requiredModules = @("Microsoft.Xrm.Tooling.CrmConnector.PowerShell")
            foreach ($module in $requiredModules) {
                if (-not(Get-Module -ListAvailable -Name $module)) {
                    Write-Verbose "$module does not exist";
                    Install-Module -Name $module -Scope CurrentUser -SkipPublisherCheck -Force -Confirm:$false -AllowClobber;
                }
                Import-Module -Name $module -DisableNameChecking;
                Write-Verbose " > Loading module : '$module' => OK !";
            }
            $XrmClient = Get-CrmConnection -InteractiveMode;
        }
        if (-not $XrmClient.IsReady) {
            $Global:XrmContext.IsUserConnected = $false;
            throw $XrmClient.LastCrmError;
        }

        # Store new context
        if ($PSBoundParameters.ContainsKey('ConnectionString')) {
            $Global:XrmContext = New-XrmContext -XrmClient $XrmClient -ConnectionString $ConnectionString;
        } 
        else{
            $Global:XrmContext = New-XrmContext -XrmClient $XrmClient;
        }

        # Store client to simplify commands execution
        $Global:XrmClient = $XrmClient;

        # Try to use admin commands
        Connect-XrmAdmin -ErrorAction SilentlyContinue;

        if ($PSBoundParameters.ContainsKey('ConnectionString')) {
            $userName = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "Username";
        }
        if (-not $userName) {
            $userName = $userId;
        }
        
        if (-not $Quiet) {
            Write-HostAndLog -Message "Connected to $($XrmClient.ConnectedOrgFriendlyName)! [Url = $($Global:XrmContext.CurrentUrl) | User : $userName]" -ForegroundColor Yellow; 
        }
        $XrmClient;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmClient -Alias *;