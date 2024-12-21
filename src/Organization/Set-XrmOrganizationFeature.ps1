<#
    .SYNOPSIS
    Set Organization Feature.

    .DESCRIPTION
    Define specific feature for default organization (see : Get-XrmOrganization)

    .PARAMETER Name
    Feature name to set.

    .PARAMETER Value
    Feature value to set.
#>
function Set-XrmOrganizationFeature {
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
        [ValidateNotNullOrEmpty()]
        [String]
        $Value
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $features = $XrmClient | Get-XrmOrganizationFeatures;

        $featuresXml = "<features>";
        foreach ($featureKey in $features.Keys) {
            if ($featureKey -eq $Name) {
                if ($features[$featureKey] -eq $Value) {
                    return;
                }
                continue;
            }
            $featureValue = $features[$featureKey];

            $featuresXml += '<feature xmlns:i="http://www.w3.org/2001/XMLSchema-instance">';
            $featuresXml += "<name>$featureKey</name>";
            $featuresXml += "<value>$featureValue</value>";
            $featuresXml += '</feature>';
        }
        $featuresXml += '<feature xmlns:i="http://www.w3.org/2001/XMLSchema-instance">';
        $featuresXml += "<name>$Name</name>";
        $featuresXml += "<value>$Value</value>";
        $featuresXml += "</feature>";
        $featuresXml += "</features>";

        $currentOrganization = $XrmClient | Get-XrmOrganization -Columns "organizationid";
        $organizationUpdate = $currentOrganization.Record;
        $organizationUpdate | Set-XrmAttributeValue -Name "featureset" -Value $featuresXml | Out-Null;
        $XrmClient | Update-XrmRecord -Record $organizationUpdate;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmOrganizationFeature -Alias *;