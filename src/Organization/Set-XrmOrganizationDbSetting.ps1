<#
    .SYNOPSIS
    Set Organization setting.

    .DESCRIPTION
    Add or update orgdbsetting value.    

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
    
    .PARAMETER Name
    Setting name to define.

    .PARAMETER Value
    Setting value to define.
#>
function Set-XrmOrganizationDbSetting {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [String]
        $Value
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $organization = $XrmClient | Get-XrmOrganization -Columns "orgdborgsettings";
        $settingsXml = [xml] $organization.orgdborgsettings;

        # Check if setting exist
        $settingProperty = $settingsXml.OrgSettings | Get-Member -MemberType Property | Where-Object Name -EQ $Name;
        if (-not $settingProperty) {
            $childNode = $settingsXml.CreateElement($Name);
            $childNode.InnerText = $Value;
            $parentNode = $settingsXml.SelectSingleNode("OrgSettings");
            $parentNode.AppendChild($childNode) | Out-Null;
        }
        else {
            $node = $settingsXml.SelectSingleNode("OrgSettings/$Name");
            $node.InnerText = $Value;
        }

        $organizationUpdate = New-XrmEntity -LogicalName "organization" -Id $organization.Id -Attributes @{
            "orgdborgsettings" = $settingsXml.OuterXml
        };
        $XrmClient | Update-XrmRecord -Record $organizationUpdate;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmOrganizationDbSetting -Alias *;