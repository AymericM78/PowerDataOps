<#
    Integration Test: Plugin Steps (brief W08)
    Registers a no-op plug-in compiled on the fly (signed .NET Framework assembly), with one step and one image, then tests
    Get-XrmPluginSteps, Disable-XrmPluginStep, Enable-XrmPluginStep and Remove-XrmPluginAssembly.
    The test never modifies Microsoft steps: the platform refuses it.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$assemblyName = "PdoTest.Plugins$suffix";
$source = @"
using System;
using Microsoft.Xrm.Sdk;
namespace PdoTest
{
    public class NoOpPlugin : IPlugin
    {
        public void Execute(IServiceProvider serviceProvider) { }
    }
}
"@;

# ============================================================
# Setup: assembly, plug-in type, step, image
# ============================================================
Write-Section "Setup - register a test plug-in";

$assemblyPath = New-TestPluginAssembly -AssemblyName $assemblyName -Source $source;
if (-not $assemblyPath) {
    Write-Host "  [SKIP] .NET Framework compiler not available: plug-in tests skipped" -ForegroundColor Yellow;
    Write-TestSummary;
    return;
}
$Global:XrmClient | Upsert-XrmAssembly -AssemblyPath $assemblyPath;
$assembly = $Global:XrmClient | Get-XrmRecord -LogicalName "pluginassembly" -AttributeName "name" -Value $assemblyName -Columns "name";
Assert-Test "Assembly registered" { $null -ne $assembly };

$typeId = $Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "plugintype" -Attributes @{
        typename = "PdoTest.NoOpPlugin"; name = "PdoTest.NoOpPlugin"; friendlyname = "NoOpPlugin"; pluginassemblyid = $assembly.Reference
    });
$message = $Global:XrmClient | Get-XrmRecord -LogicalName "sdkmessage" -AttributeName "name" -Value "Create" -Columns "name";
$filterQuery = New-XrmQueryExpression -LogicalName "sdkmessagefilter" -Columns "primaryobjecttypecode";
$filterQuery = $filterQuery | Add-XrmQueryCondition -Field "sdkmessageid" -Condition Equal -Values $message.Id;
$filterQuery = $filterQuery | Add-XrmQueryCondition -Field "primaryobjecttypecode" -Condition Equal -Values "letter";
$filter = @($Global:XrmClient | Get-XrmMultipleRecords -Query $filterQuery)[0];
$stepId = $Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "sdkmessageprocessingstep" -Attributes @{
        name                = "PdoTest NoOp: Create of letter";
        eventhandler        = (New-XrmEntityReference -LogicalName "plugintype" -Id $typeId);
        sdkmessageid        = $message.Reference;
        sdkmessagefilterid  = $filter.Reference;
        stage               = (New-XrmOptionSetValue -Value 40);
        mode                = (New-XrmOptionSetValue -Value 0);
        rank                = 1;
        supporteddeployment = (New-XrmOptionSetValue -Value 0);
    });
$imageId = $Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "sdkmessageprocessingstepimage" -Attributes @{
        sdkmessageprocessingstepid = (New-XrmEntityReference -LogicalName "sdkmessageprocessingstep" -Id $stepId);
        imagetype                  = (New-XrmOptionSetValue -Value 1);
        messagepropertyname        = "Id";
        entityalias                = "post";
        name                       = "post";
        attributes                 = "subject";
    });
Assert-Test "Plug-in type, step and image registered" { $typeId -ne [Guid]::Empty -and $stepId -ne [Guid]::Empty -and $imageId -ne [Guid]::Empty };

# ============================================================
# Get-XrmPluginSteps
# ============================================================
Write-Section "Get-XrmPluginSteps";

$byAssembly = @(Get-XrmPluginSteps -XrmClient $Global:XrmClient -AssemblyName $assemblyName);
Assert-Test "-AssemblyName: the test step, with its assembly, type, message and table" {
    $byAssembly.Count -eq 1 -and $byAssembly[0].Id -eq $stepId -and $byAssembly[0].AssemblyName -eq $assemblyName -and $byAssembly[0].PluginTypeName -eq "PdoTest.NoOpPlugin" -and $byAssembly[0].MessageName -eq "Create" -and $byAssembly[0].EntityLogicalName -eq "letter";
};

$byTable = @(Get-XrmPluginSteps -XrmClient $Global:XrmClient -EntityLogicalName "letter" -MessageName "Create" -ActiveOnly -CustomOnly);
Assert-Test "-EntityLogicalName -MessageName -ActiveOnly -CustomOnly: includes the test step, every row matches" {
    @($byTable | Where-Object { $_.Id -eq $stepId }).Count -eq 1 -and @($byTable | Where-Object { $_.EntityLogicalName -ne "letter" -or $_.MessageName -ne "Create" -or $_.statecode_Value.Value -ne 0 }).Count -eq 0;
};

$custom = @(Get-XrmPluginSteps -XrmClient $Global:XrmClient -CustomOnly);
Assert-Test "-CustomOnly: no Microsoft assembly, no hidden step" {
    @($custom | Where-Object { $_.AssemblyName -like "Microsoft.*" -or $_.Record["ishidden"].Value }).Count -eq 0 -and @($custom | Where-Object { $_.Id -eq $stepId }).Count -eq 1;
};

# ============================================================
# Disable-XrmPluginStep / Enable-XrmPluginStep
# ============================================================
Write-Section "Disable-XrmPluginStep / Enable-XrmPluginStep";

$stepRef = $byAssembly[0].Reference;
$Global:XrmClient | Disable-XrmPluginStep -PluginStepReference $stepRef | Out-Null;
$inactive = @(Get-XrmPluginSteps -XrmClient $Global:XrmClient -AssemblyName $assemblyName -ActiveOnly);
Assert-Test "Disable-XrmPluginStep: step disabled, excluded by -ActiveOnly" { $inactive.Count -eq 0 };

$Global:XrmClient | Enable-XrmPluginStep -PluginStepReference $stepRef | Out-Null;
$active = @(Get-XrmPluginSteps -XrmClient $Global:XrmClient -AssemblyName $assemblyName -ActiveOnly);
Assert-Test "Enable-XrmPluginStep: step enabled again" { $active.Count -eq 1 };

# ============================================================
# Remove-XrmPluginAssembly
# ============================================================
Write-Section "Remove-XrmPluginAssembly";

$managedAssembly = @($Global:XrmClient | Get-XrmMultipleRecords -Query (New-XrmQueryExpression -LogicalName "pluginassembly" -Columns "name" -TopCount 1 | Add-XrmQueryCondition -Field "ismanaged" -Condition Equal -Values $true))[0];
$managedError = $null;
try { Remove-XrmPluginAssembly -XrmClient $Global:XrmClient -Name $managedAssembly.name -Force -WhatIf | Out-Null; } catch { $managedError = $_.Exception.Message; }
Assert-Test "Managed assembly: refused before any deletion" { $managedError -like "*is managed*" };

$stepsError = $null;
try { Remove-XrmPluginAssembly -XrmClient $Global:XrmClient -Name $assemblyName | Out-Null; } catch { $stepsError = $_.Exception.Message; }
Assert-Test "Without -Force: refused, the step is kept" { $stepsError -like "*1 step*-Force*" -and $null -ne ($Global:XrmClient | Get-XrmRecord -LogicalName "sdkmessageprocessingstep" -Id $stepId -IfExists) };

$removed = Remove-XrmPluginAssembly -XrmClient $Global:XrmClient -Name $assemblyName -Force;
Assert-Test "-Force: step, type and assembly deleted" {
    $removed.StepsRemoved -eq 1 -and $removed.TypesRemoved -eq 1 -and
    $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "sdkmessageprocessingstep" -Id $stepId -IfExists) -and
    $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "sdkmessageprocessingstepimage" -Id $imageId -IfExists) -and
    $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "plugintype" -Id $typeId -IfExists) -and
    $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "pluginassembly" -Id $assembly.Id -IfExists);
};

$missingError = $null;
try { Remove-XrmPluginAssembly -XrmClient $Global:XrmClient -Name $assemblyName | Out-Null; } catch { $missingError = $_.Exception.Message; }
Assert-Test "Missing assembly: error" { $missingError -like "*not found*" };

# Safety net when an assertion above failed
if ($Global:XrmClient | Get-XrmRecord -LogicalName "pluginassembly" -Id $assembly.Id -IfExists) {
    try { Remove-XrmPluginAssembly -XrmClient $Global:XrmClient -Name $assemblyName -Force | Out-Null; } catch { Write-Host "  Cleanup failed: $($_.Exception.Message)" -ForegroundColor Red; }
}
Remove-Item -Path (Split-Path $assemblyPath -Parent) -Recurse -Force -ErrorAction SilentlyContinue;

Write-TestSummary;
