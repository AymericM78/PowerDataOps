<#
    .SYNOPSIS
    Get Solution Components.

    .DESCRIPTION
    Retrieve components from given solution and expected types.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name where to get components.

    .PARAMETER ComponentTypes
    Array of component types number to retrieve. (Default: none = retrieve all components)
#>
function Get-XrmSolutionComponents {
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
        $ComponentTypes = @()
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $solution = $XrmClient | Get-XrmRecord -LogicalName "solution" -AttributeName "uniquename" -Value $SolutionUniqueName;
        if (-not $solution) {
            Write-HostAndLog -Message "Solution $SolutionUniqueName not found" -Level FAIL;
            return $null;
        }
        
        $querySolutionComponents = New-XrmQueryExpression -LogicalName "solutioncomponent" -Columns "objectid", "componenttype";
        $querySolutionComponents = $querySolutionComponents | Add-XrmQueryCondition -Field "solutionid" -Condition Equal -Values $solution.Id;
        if ($ComponentTypes.Count -gt 0) {
            $querySolutionComponents = $querySolutionComponents | Add-XrmQueryCondition -Field "componenttype" -Condition In -Values $ComponentTypes;
        }
        $components = $XrmClient | Get-XrmMultipleRecords -Query $querySolutionComponents;

        $components;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmSolutionComponents -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmSolutionComponents -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}