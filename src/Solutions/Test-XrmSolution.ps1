<#
    .SYNOPSIS
    Verify whether a Dataverse solution exists.

    .DESCRIPTION
    Return $true when a solution exists for the specified unique name.
    With Managed, return $true only when the solution exists and is managed; with Unmanaged, only when it exists and is unmanaged.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Solution unique name to check.

    .PARAMETER Managed
    Also require the solution to be managed.

    .PARAMETER Unmanaged
    Also require the solution to be unmanaged.

    .OUTPUTS
    System.Boolean.

    .EXAMPLE
    Test-XrmSolution -SolutionUniqueName "contoso_core";

    .EXAMPLE
    if (Test-XrmSolution -XrmClient $xrmClient -SolutionUniqueName "contoso_core" -Managed) { Write-Host "Installed as managed"; }

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmSolution.md
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
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [switch]
        $Managed,

        [Parameter(Mandatory = $false)]
        [switch]
        $Unmanaged
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($Managed -and $Unmanaged) {
            throw "Use either Managed or Unmanaged, not both.";
        }
        $solution = Get-XrmSolution -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -Columns @("solutionid", "ismanaged");
        if ($null -eq $solution) {
            return $false;
        }
        $isManaged = [bool]($solution | Get-XrmAttributeValue -Name "ismanaged");
        if ($Managed) {
            return $isManaged;
        }
        if ($Unmanaged) {
            return -not $isManaged;
        }
        $true;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmSolution -Alias *;
