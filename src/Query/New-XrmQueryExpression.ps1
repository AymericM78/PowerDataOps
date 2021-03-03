<#
    .SYNOPSIS
    Return QueryExpression object instance.

    .DESCRIPTION
    Initialize new query expression object.

    .PARAMETER LogicalName
    Gets or sets the entity name for the condition.

    .PARAMETER Columns
    Gets or sets the columns to return in the query results.

    .PARAMETER TopCount
    Gets or sets the number of rows to be returned.
#>
function New-XrmQueryExpression {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.Query.QueryExpression")]
    param
    (        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]   
        [String]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [String[]]
        $Columns,
        
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $TopCount = 1000
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $query = New-Object -TypeName "Microsoft.Xrm.Sdk.Query.QueryExpression" -ArgumentList $LogicalName;
        if ($PSBoundParameters.ContainsKey('Columns')) {
            if ($Columns.Contains("*")) {
                $query.ColumnSet.AllColumns = $true;
            }
            else {
                $Columns | ForEach-Object {
                    $query.ColumnSet.AddColumn($_);
                }
            }
        }
        $query.NoLock = $true;
        if ($PSBoundParameters.ContainsKey('TopCount')) {
            $query.TopCount = $TopCount;
        }
        $query;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmQueryExpression -Alias *;

Register-ArgumentCompleter -CommandName New-XrmQueryExpression -ParameterName "LogicalName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

Register-ArgumentCompleter -CommandName New-XrmQueryExpression -ParameterName "Columns" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    if (-not ($fakeBoundParameters.ContainsKey("LogicalName"))) {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.LogicalName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}