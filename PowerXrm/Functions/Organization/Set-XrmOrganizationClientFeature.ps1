<#
    .SYNOPSIS
    Set Organization Client Feature
#>
function Set-XrmOrganizationClientFeature {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
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
        $features = $XrmClient | Get-XrmOrganizationClientFeatures;

        $featuresXml = "<clientfeatures>";
        foreach($featureKey in $features.Keys)
        {
            if($featureKey -eq $Name)
            {
                continue;
            }
            $featureValue = $features[$featureKey];

            $featuresXml += '<clientfeature xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-Instance">';
            $featuresXml += "<name>$featureKey</name>";
            $featuresXml += "<value>$featureValue</value>";
            $featuresXml += '</clientfeature>';
        }
        $featuresXml += '<clientfeature xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-Instance">';
        $featuresXml += "<name>$Name</name>";
        $featuresXml += "<value>$Value</value>";
        $featuresXml += '</clientfeature>';
        $featuresXml += "</clientfeatures>";

        $currentOrganization = $XrmClient | Get-XrmOrganization -Columns "organizationid";
        $organizationUpdate = $currentOrganization.Record;
        $organizationUpdate | Set-XrmAttributeValue -Name "clientfeatureset" -Value $featuresXml | Out-Null;
        $XrmClient | Update-XrmRecord -Record $organizationUpdate;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmOrganizationClientFeature -Alias *;