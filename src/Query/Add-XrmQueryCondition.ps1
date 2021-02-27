<#
    .SYNOPSIS
    Add filter to given query expression
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
        [System.Object[]]
        $Values
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        
        if ($PSBoundParameters.ContainsKey('Values')) {
            if ($PSBoundParameters.ContainsKey('CompareFieldValue')) {
                $Query.Criteria.AddCondition($Field, $Condition, $true, $Values);
            }
            else {
                $Query.Criteria.AddCondition($Field, $Condition, $Values);
            }
        }
        else {
            $Query.Criteria.AddCondition($Field, $Condition);
        }
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