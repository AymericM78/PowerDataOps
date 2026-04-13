<#
    .SYNOPSIS
    Uninstall a solution from Microsoft Dataverse.

    .DESCRIPTION
    Delete a solution (managed or unmanaged) from the environment by its unique name.
    Uses the UninstallSolutionAsync SDK message to avoid timeout issues, then monitors
    the async operation via Watch-XrmAsynchOperation until completion.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Solution unique name to uninstall.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Uninstall-XrmSolution -SolutionUniqueName "contoso_crm";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/uninstall-delete-solution
#>
function Uninstall-XrmSolution {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $solution = $XrmClient | Get-XrmSolution -SolutionUniqueName $SolutionUniqueName -Columns @("solutionid", "uniquename");
        if (-not $solution) {
            throw "Solution '$SolutionUniqueName' not found!";
        }

        $uninstallRequest = New-XrmRequest -Name "UninstallSolutionAsync";
        $uninstallRequest = $uninstallRequest | Add-XrmRequestParameter -Name "SolutionUniqueName" -Value $SolutionUniqueName;

        try {
            $response = $XrmClient | Invoke-XrmRequest -Request $uninstallRequest;
            $asyncOperationId = $response.Results["AsyncOperationId"];
            Watch-XrmAsynchOperation -AsyncOperationId $asyncOperationId -ScriptBlock {
                param($asyncOperation)

                Write-HostAndLog " > Uninstalling '$SolutionUniqueName' solution : Asyncoperation $($asyncOperation.Id) | Status = $($asyncOperation.statuscode)" -ForegroundColor Cyan;
            };
        }
        catch {
            $errorMessage = $_.Exception.Message;
            Write-HostAndLog "$($MyInvocation.MyCommand.Name) => KO : [Error: $errorMessage]" -ForegroundColor Red -Level FAIL;
            throw $errorMessage;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Uninstall-XrmSolution -Alias *;

Register-ArgumentCompleter -CommandName Uninstall-XrmSolution -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}
