<#
    .SYNOPSIS
    Retrieve query expression from fetch Xml.
    
    .DESCRIPTION
    Convert FetchXml to QueryExpression.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER FetchXml
    FetchXML query string.
#>
function Get-XrmQueryFromFetch {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FetchXml
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        # TODO : Use Web API Function => https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/fetchxmltoqueryexpression?view=dataverse-latest
        $conversionRequest = New-Object "Microsoft.Crm.Sdk.Messages.FetchXmlToQueryExpressionRequest";
        $conversionRequest.FetchXml = $FetchXml;
        $conversionResponse = $XrmClient.Execute($conversionRequest);
        $conversionResponse.Query;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmQueryFromFetch -Alias *;
