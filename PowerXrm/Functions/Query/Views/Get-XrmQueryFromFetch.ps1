<#
    .SYNOPSIS
    Retrieve query expression from fetch Xml    
#>
function Get-XrmQueryFromFetch {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
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
        $conversionRequest =  New-Object "Microsoft.Crm.Sdk.Messages.FetchXmlToQueryExpressionRequest";
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
