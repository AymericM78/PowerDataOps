<#
    .SYNOPSIS
    Add order to query expression.

    .DESCRIPTION
    Set sort order to query expression.

    .PARAMETER Query
    QueryExpression where sort should be add.

    .PARAMETER Field
    Column / attribute logical name to sort.

    .PARAMETER OrderType
    Specify order on given column : ascending or descending.
#>
function Add-XrmQueryOrder {
    [CmdletBinding()]    
    [OutputType("Microsoft.Xrm.Sdk.Query.QueryExpression")]
    param
    (        
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.Query.QueryExpression]
        $Query,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Field,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.Query.OrderType]
        $OrderType
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        $Query.AddOrder($Field, $OrderType);
        $Query;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmQueryOrder -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmQueryOrder -ParameterName "Field" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    # TODO : Search query in pipeline
    if (-not ($fakeBoundParameters.ContainsKey("Query"))) {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.Query.EntityName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}