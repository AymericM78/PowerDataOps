<#
    .SYNOPSIS
    Copy Solution Components
#>
function Copy-XrmSolutionComponents {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SourceSolutionUniqueName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TargetSolutionUniqueName
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        $sourceComponents = $XrmClient | Get-XrmSolutionComponents -SolutionUniqueName $SourceSolutionUniqueName;
        if (-not $sourceComponents) {
            return;
        }
        ForEach-ObjectWithProgress -Collection $sourceComponents -OperationName "Solution components copy from $SourceSolutionUniqueName to $TargetSolutionUniqueName" -ScriptBlock {
            param($component)

            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $TargetSolutionUniqueName -ComponentId $component.objectid -ComponentType $component.componenttype_Value.Value;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Copy-XrmSolutionComponents -Alias *;

Register-ArgumentCompleter -CommandName Copy-XrmSolutionComponents -ParameterName "SourceSolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}

Register-ArgumentCompleter -CommandName Copy-XrmSolutionComponents -ParameterName "TargetSolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}