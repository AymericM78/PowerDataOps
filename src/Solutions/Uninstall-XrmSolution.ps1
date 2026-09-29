<#
    .SYNOPSIS
    Uninstall a solution from Microsoft Dataverse.

    .DESCRIPTION
    Delete a solution (managed or unmanaged) from the environment by its unique name.
    Uses the UninstallSolutionAsync SDK message to avoid timeout issues, then monitors
    the async operation via Watch-XrmAsynchOperation until completion.
    Raises an error when the uninstall system job fails or is canceled.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Solution unique name to uninstall.

    .PARAMETER PassThru
    Return the status of the uninstall system job (see Watch-XrmAsynchOperation). (Default: nothing is returned)

    .PARAMETER OnlyIfEmpty
    Keep the solution, without error, when it still has components (an unmanaged solution used as a container).

    .PARAMETER IfExists
    Do nothing, without error, when the solution does not exist.

    .OUTPUTS
    PSCustomObject. With PassThru only: Id, StatusCode, Status, Message, FriendlyMessage of the uninstall system job.

    .EXAMPLE
    Uninstall-XrmSolution -SolutionUniqueName "contoso_crm";

    .EXAMPLE
    $status = Uninstall-XrmSolution -XrmClient $xrmClient -SolutionUniqueName "contoso_crm" -PassThru;

    .EXAMPLE
    # Idempotent cleanup of a temporary container solution (alias Remove-XrmSolution)
    Remove-XrmSolution -XrmClient $xrmClient -SolutionUniqueName "contoso_temp" -OnlyIfEmpty -IfExists;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Uninstall-XrmSolution.md
#>
function Uninstall-XrmSolution {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
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
        [switch]
        $PassThru,

        [Parameter(Mandatory = $false)]
        [switch]
        $OnlyIfEmpty,

        [Parameter(Mandatory = $false)]
        [switch]
        $IfExists
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $solution = $XrmClient | Get-XrmSolution -SolutionUniqueName $SolutionUniqueName -Columns @("solutionid", "uniquename");
        if (-not $solution) {
            if ($IfExists) {
                return;
            }
            throw "Solution '$SolutionUniqueName' not found!";
        }
        if ($OnlyIfEmpty) {
            $components = @(Get-XrmSolutionComponents -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -IfExists);
            if ($components.Count -gt 0) {
                Write-Verbose "Solution '$SolutionUniqueName' kept: it has $($components.Count) component(s).";
                return;
            }
        }

        $uninstallRequest = New-XrmRequest -Name "UninstallSolutionAsync";
        $uninstallRequest = $uninstallRequest | Add-XrmRequestParameter -Name "SolutionUniqueName" -Value $SolutionUniqueName;

        try {
            $response = $XrmClient | Invoke-XrmRequest -Request $uninstallRequest;
            if ($WhatIfPreference -and $null -eq $response) { return; }
            $asyncOperationId = $response.Results["AsyncOperationId"];
            $uninstallStatus = $XrmClient | Watch-XrmAsynchOperation -AsyncOperationId $asyncOperationId -MissingMeansSucceeded -ThrowOnFailure -ScriptBlock {
                param($asyncOperation)

                Write-HostAndLog " > Uninstalling '$SolutionUniqueName' solution : Asyncoperation $($asyncOperation.Id) | Status = $($asyncOperation.statuscode)" -ForegroundColor Cyan;
            };
        }
        catch {
            $errorMessage = $_.Exception.Message;
            Write-HostAndLog "$($MyInvocation.MyCommand.Name) => KO : [Error: $errorMessage]" -ForegroundColor Red -Level FAIL;
            throw $errorMessage;
        }

        if ($PassThru) {
            $uninstallStatus;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Set-Alias -Name Remove-XrmSolution -Value Uninstall-XrmSolution;
Export-ModuleMember -Function Uninstall-XrmSolution -Alias *;

Register-ArgumentCompleter -CommandName Uninstall-XrmSolution -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}
