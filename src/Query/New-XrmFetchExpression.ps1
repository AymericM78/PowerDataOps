<#
    .SYNOPSIS
    Return a fetch expression from fetch xml

    .DESCRIPTION
    Initialize new fetch expression object.

    .PARAMETER FetchXml
    FetchXML query string.
#>
function New-XrmFetchExpression {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.Query.FetchExpression")]
    param
    (
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
        $fetchExpression = New-Object -TypeName "Microsoft.Xrm.Sdk.Query.FetchExpression" -ArgumentList $FetchXml;
        $fetchExpression;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmFetchExpression -Alias *;