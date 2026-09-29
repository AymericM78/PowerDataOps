<#
    .SYNOPSIS
    Call a custom API repeatedly, while a condition holds, up to a ceiling.

    .DESCRIPTION
    Call the custom API (see Invoke-XrmCustomApi) until the While scriptblock returns false or MaxIterations calls were made: the "process by batches until nothing is left" pattern.
    The While and OnIteration scriptblocks receive the output of the last call in $_ (the response, or the deserialized JSON with JsonOutput), and the output and the iteration number as arguments.
    OnIteration output goes to the host. A failed call stops the loop with an error.
    Returns Iterations, LastOutput and CeilingReached (true when the loop stopped on MaxIterations while While still returned true).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Custom API unique name (message name).

    .PARAMETER Parameters
    Request parameters, by name, sent at each call. (Default: none)

    .PARAMETER While
    Condition evaluated after each call: the loop goes on while it returns true (e.g. { $_.HasMore }).

    .PARAMETER MaxIterations
    Maximum number of calls. (Default: 100)

    .PARAMETER OnIteration
    Scriptblock run after each call, before While (e.g. to log progress).

    .PARAMETER JsonOutput
    Name of an output parameter holding JSON: its deserialized value is given to the scriptblocks and returned as LastOutput.

    .OUTPUTS
    PSCustomObject. Iterations, LastOutput, CeilingReached.

    .EXAMPLE
    $result = Invoke-XrmCustomApiLoop -XrmClient $xrmClient -Name "contoso_PurgeLogs" -Parameters @{ BatchSize = 500 } -JsonOutput "Result" `
        -While { $_.HasMore } -MaxIterations 200 -OnIteration { param($output, $iteration) Write-Host "Batch $iteration : $($output.Deleted) deleted" };
    if ($result.CeilingReached) { Write-Warning "Stopped after $($result.Iterations) batches, logs remain."; }

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmCustomApiLoop.md
#>
function Invoke-XrmCustomApiLoop {
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
        $Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Hashtable]
        $Parameters,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [ScriptBlock]
        $While,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $MaxIterations = 100,

        [Parameter(Mandatory = $false)]
        [ScriptBlock]
        $OnIteration,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $JsonOutput
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $callParameters = @{ XrmClient = $XrmClient; Name = $Name; ErrorAction = "Stop" };
        if ($PSBoundParameters.ContainsKey('Parameters')) {
            $callParameters["Parameters"] = $Parameters;
        }
        if ($PSBoundParameters.ContainsKey('JsonOutput')) {
            $callParameters["JsonOutput"] = $JsonOutput;
        }

        $iteration = 0;
        $output = $null;
        $continue = $true;
        while ($continue -and $iteration -lt $MaxIterations) {
            $iteration++;
            $output = Invoke-XrmCustomApi @callParameters;
            if ($WhatIfPreference -and $null -eq $output) {
                # Call skipped: nothing to evaluate
                $continue = $false;
                break;
            }

            $context = [System.Collections.Generic.List[psvariable]]::new();
            $context.Add([psvariable]::new("_", $output));
            if ($OnIteration) {
                $OnIteration.InvokeWithContext($null, $context, @($output, $iteration)) | Out-Host;
            }
            $condition = $While.InvokeWithContext($null, $context, @($output, $iteration));
            $continue = [bool]($condition | Select-Object -Last 1);
        }

        [PSCustomObject]@{
            Iterations     = $iteration;
            LastOutput     = $output;
            CeilingReached = $continue -and $iteration -ge $MaxIterations;
        };
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Invoke-XrmCustomApiLoop -Alias *;
