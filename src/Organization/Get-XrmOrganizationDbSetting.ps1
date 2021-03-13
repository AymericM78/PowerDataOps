<#
    .SYNOPSIS
    Get Organization setting.

    .DESCRIPTION
    Retrieve organization setting (orgdbsetting) from target instance.    

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
    
    .PARAMETER Name
    Setting name to retrieve.
#>
function Get-XrmOrganizationDbSetting {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $organization = $XrmClient | Get-XrmOrganization -Columns "orgdborgsettings";
        $settingsXml = [xml] $organization.orgdborgsettings;
        if ($Name) {
            return $settingsXml.OrgSettings.$Name; 
        }
        $settingsXml.OrgSettings;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmOrganizationDbSetting -Alias *;