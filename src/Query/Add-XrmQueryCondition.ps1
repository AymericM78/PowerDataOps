<#
    .SYNOPSIS
    Add filter to given query expression.

    .DESCRIPTION
    Add new condition criteria to given query expression.

    .PARAMETER Query
    QueryExpression where condition should be add.

    .PARAMETER Field
    Column / attribute logical name to filter.

    .PARAMETER Condition
    Condition operator to apply to column (ConditionOperator)

    .PARAMETER CompareFieldValue
    Specify if column filter should be evaluated according to another column.

    .PARAMETER Values
    Value to apply in column filter (single object or array). Values are unwrapped from their PowerShell PSObject adapter. An empty array with In matches no row; an empty array with NotIn adds no condition.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Query.QueryExpression. The query, for pipeline chaining.

    .EXAMPLE
    $query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
    $query = $query | Add-XrmQueryCondition -Field "statecode" -Condition Equal -Values 0;

    .EXAMPLE
    $query = $query | Add-XrmQueryCondition -Field "accountid" -Condition In -Values $accountIds;
#>
function Add-XrmQueryCondition {
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
        [Microsoft.Xrm.Sdk.Query.ConditionOperator]
        $Condition,

        [Parameter(Mandatory = $false)]
        [switch]
        $CompareFieldValue = $false,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [System.Object[]]
        $Values
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        Add-XrmFilterConditionInternal -Filter $Query.Criteria -Field $Field -Condition $Condition -HasValues $PSBoundParameters.ContainsKey('Values') -Values $Values -CompareFieldValue $CompareFieldValue.IsPresent;
        $Query;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmQueryCondition -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmQueryCondition -ParameterName "Field" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    # TODO : Search query in pipeline
    if (-not ($fakeBoundParameters.ContainsKey("Query"))) {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.Query.EntityName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}