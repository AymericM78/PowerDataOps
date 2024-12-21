<#
    .SYNOPSIS
    Clear active customizations for given solution components.

    .DESCRIPTION
    Performs a cleaning on Active Layer to remove unmanaged customizations for given component types.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Solution unique name where to get components to clean.

    .PARAMETER ComponentTypes
    Solution components types number to clean. (Default = 26, 59, 60, 61, 62, 300 = SavedQuery, SavedQueryVisualization, SystemForm, WebResource, SiteMap, Canvas App)
#>
function Clear-XrmActiveCustomizations {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $ComponentTypes = @(26, 59, 60, 61, 62, 300)
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $components = Get-XrmSolutionComponents -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentTypes $ComponentTypes;
        ForEach-ObjectWithProgress -Collection $components -OperationName "Clearing active customizations for $SolutionUniqueName solution" -ScriptBlock {
            param($component)

            $componentName = Get-XrmSolutionComponentName -SolutionComponentType $component.componenttype_Value.Value;
            Remove-XrmActiveCustomizations -XrmClient $XrmClient -SolutionComponentName $componentName -ComponentId $component.objectid;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Clear-XrmActiveCustomizations -Alias *;

Register-ArgumentCompleter -CommandName Clear-XrmActiveCustomizations -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}