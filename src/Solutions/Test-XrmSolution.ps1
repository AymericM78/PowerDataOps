<#
    .SYNOPSIS
    Verify whether a Dataverse solution exists.

    .DESCRIPTION
    Return $true when a solution exists for the specified unique name.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Solution unique name to check.

    .OUTPUTS
    System.Boolean.

    .EXAMPLE
    Test-XrmSolution -SolutionUniqueName "contoso_core";
#>
function Test-XrmSolution {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $solution = Get-XrmSolution -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -Columns @("solutionid");
        [bool]($null -ne $solution);
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmSolution -Alias *;