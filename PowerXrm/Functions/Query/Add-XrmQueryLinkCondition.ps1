<#
    .SYNOPSIS
    Add filter to given link entity
#>
function Add-XrmQueryLinkCondition {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.Query.LinkEntity")]
    param
    (        
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.Query.LinkEntity]
        $Link,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Field,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.Query.ConditionOperator]
        $Condition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Object[]]
        $Values
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        
        if ($Values) {
            $Link.LinkCriteria.AddCondition($Field, $Condition, $Values);
        }
        else {
            $Link.LinkCriteria.AddCondition($Field, $Condition);
        }
        $Link;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmQueryLinkCondition -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmQueryLinkCondition -ParameterName "Field" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    # TODO : Search query in pipeline
    if (-not ($fakeBoundParameters.ContainsKey("Query"))) {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.Query.EntityName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}