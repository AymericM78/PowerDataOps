<#
    .SYNOPSIS
    Delete a plug-in assembly with its steps and plug-in types.

    .DESCRIPTION
    Delete the steps of the assembly (their images go with them), then its plug-in types, then the assembly itself.
    Without Force, raises an error when the assembly still has steps, and deletes nothing.
    Raises an error, before deleting anything, when the assembly is managed (remove it by uninstalling its solution) or does not exist.
    A plug-in type used by a custom API or a custom workflow activity cannot be deleted: the platform error is raised and the assembly is kept.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Plug-in assembly name (pluginassembly.name, without version).

    .PARAMETER Force
    Delete the steps registered on the assembly first.

    .OUTPUTS
    PSCustomObject. AssemblyId, StepsRemoved, TypesRemoved.

    .EXAMPLE
    Remove-XrmPluginAssembly -XrmClient $xrmClient -Name "Contoso.Plugins.Legacy" -Force;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmPluginAssembly.md
#>
function Remove-XrmPluginAssembly {
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
        [switch]
        $Force
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $assembly = $XrmClient | Get-XrmRecord -LogicalName "pluginassembly" -AttributeName "name" -Value $Name -Columns "name", "ismanaged" -AsEntity;
        if (-not $assembly) {
            throw "Plug-in assembly '$Name' not found.";
        }
        if ($assembly["ismanaged"]) {
            throw "Plug-in assembly '$Name' is managed: uninstall its solution to remove it.";
        }

        $typeQuery = New-XrmQueryExpression -LogicalName "plugintype" -Columns "typename";
        $typeQuery = $typeQuery | Add-XrmQueryCondition -Field "pluginassemblyid" -Condition Equal -Values $assembly.Id;
        $types = $XrmClient | Get-XrmMultipleRecords -Query $typeQuery -AsEntity -AsArray;

        $steps = @();
        if ($types.Count -gt 0) {
            $stepQuery = New-XrmQueryExpression -LogicalName "sdkmessageprocessingstep" -Columns "name";
            $stepQuery = $stepQuery | Add-XrmQueryCondition -Field "eventhandler" -Condition In -Values @($types | ForEach-Object { $_.Id });
            $steps = $XrmClient | Get-XrmMultipleRecords -Query $stepQuery -AsEntity -AsArray;
        }
        if ($steps.Count -gt 0 -and -not $Force) {
            throw "Plug-in assembly '$Name' still has $($steps.Count) step(s): use -Force to delete them with the assembly.";
        }

        # Each deletion stops the process on failure: the assembly stays when a type cannot be deleted
        foreach ($step in $steps) {
            try {
                $XrmClient | Remove-XrmRecord -LogicalName "sdkmessageprocessingstep" -Id $step.Id -ErrorAction Stop;
            }
            catch {
                throw "Cannot delete step '$($step["name"])' of plug-in assembly '$Name': $($_.Exception.Message)";
            }
        }
        foreach ($type in $types) {
            try {
                $XrmClient | Remove-XrmRecord -LogicalName "plugintype" -Id $type.Id -ErrorAction Stop;
            }
            catch {
                throw "Cannot delete plug-in type '$($type["typename"])' of plug-in assembly '$Name': $($_.Exception.Message)";
            }
        }
        try {
            $XrmClient | Remove-XrmRecord -LogicalName "pluginassembly" -Id $assembly.Id -ErrorAction Stop;
        }
        catch {
            throw "Cannot delete plug-in assembly '$Name': $($_.Exception.Message)";
        }
        if ($WhatIfPreference) {
            return;
        }

        [PSCustomObject]@{
            AssemblyId   = $assembly.Id;
            StepsRemoved = $steps.Count;
            TypesRemoved = $types.Count;
        };
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmPluginAssembly -Alias *;
