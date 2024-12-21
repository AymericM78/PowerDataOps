<#
    .SYNOPSIS
    Get Organization Features

    .DESCRIPTION
    Retrieve all or specified features from default organization (see : Get-XrmOrganization)

    .PARAMETER Name
    Feature name to retrieve.
#>
function Get-XrmOrganizationFeatures {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
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
        $organization = $XrmClient | Get-XrmOrganization -Columns "featureset";
        $features = @{};

        if ($organization.featureset) {
            $featuresXml = [xml] $organization.featureset;
            if ($Name) {
                $feature = $featuresXml.features.feature | where-object -Property name -eq $Name; 
                if ($feature) {
                    $features[$feature.name] = $feature.value;
                }
            }
            else {
                foreach ($feature in $featuresXml.features.feature) {
                    $features[$feature.name] = $feature.value;
                }                
            }
        }
        return $features;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmOrganizationFeatures -Alias *;