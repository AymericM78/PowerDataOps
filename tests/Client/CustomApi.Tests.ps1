<#
    Integration Test: custom APIs (brief W11, W12)
    Registers an echo custom API backed by a plug-in compiled on the fly, then tests Invoke-XrmCustomApi and Invoke-XrmCustomApiLoop.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# Any SDK message
# ============================================================
Write-Section "Invoke-XrmCustomApi on a platform message";

$whoAmI = Invoke-XrmCustomApi -XrmClient $Global:XrmClient -Name "WhoAmI";
Assert-Test "WhoAmI: response returned" { $null -ne $whoAmI -and $whoAmI.Results["UserId"] -ne [Guid]::Empty };

$outputError = $null;
try { Invoke-XrmCustomApi -XrmClient $Global:XrmClient -Name "WhoAmI" -JsonOutput "Missing" | Out-Null; } catch { $outputError = $_.Exception.Message; }
Assert-Test "-JsonOutput on a missing output: error listing the outputs" { $outputError -like "*Missing*UserId*" };

# ============================================================
# Setup: echo custom API
# ============================================================
Write-Section "Setup - echo custom API";

$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$assemblyName = "PdoTest.CustomApi$suffix";
$apiName = "new_PdoEcho$suffix";
$source = @"
using System;
using Microsoft.Xrm.Sdk;
namespace PdoTest
{
    public class EchoApi : IPlugin
    {
        public void Execute(IServiceProvider serviceProvider)
        {
            var context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
            var input = context.InputParameters.Contains("Input") ? (string)context.InputParameters["Input"] : "";
            context.OutputParameters["Result"] = "{\"Echo\":\"" + input + "\",\"Length\":" + input.Length + "}";
        }
    }
}
"@;
$assemblyPath = New-TestPluginAssembly -AssemblyName $assemblyName -Source $source;
if (-not $assemblyPath) {
    Write-Host "  [SKIP] .NET Framework compiler not available: custom API tests skipped" -ForegroundColor Yellow;
    Write-TestSummary;
    return;
}
$Global:XrmClient | Upsert-XrmAssembly -AssemblyPath $assemblyPath;
$assembly = $Global:XrmClient | Get-XrmRecord -LogicalName "pluginassembly" -AttributeName "name" -Value $assemblyName -Columns "name";
$typeId = $Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "plugintype" -Attributes @{
        typename = "PdoTest.EchoApi"; name = "PdoTest.EchoApi"; friendlyname = "EchoApi"; pluginassemblyid = $assembly.Reference
    });
$apiId = $Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "customapi" -Attributes @{
        uniquename = $apiName; name = $apiName; displayname = "PDO Echo"; description = "PowerDataOps integration test";
        bindingtype = (New-XrmOptionSetValue -Value 0); isfunction = $false; allowedcustomprocessingsteptype = (New-XrmOptionSetValue -Value 0);
        plugintypeid = (New-XrmEntityReference -LogicalName "plugintype" -Id $typeId)
    });
$apiRef = New-XrmEntityReference -LogicalName "customapi" -Id $apiId;
$Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "customapirequestparameter" -Attributes @{
        customapiid = $apiRef; uniquename = "Input"; name = "$apiName.Input"; displayname = "Input"; description = "Text to echo"; type = (New-XrmOptionSetValue -Value 10); isoptional = $true
    }) | Out-Null;
$Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "customapiresponseproperty" -Attributes @{
        customapiid = $apiRef; uniquename = "Result"; name = "$apiName.Result"; displayname = "Result"; description = "JSON result"; type = (New-XrmOptionSetValue -Value 10)
    }) | Out-Null;
Assert-Test "Custom API registered" { $apiId -ne [Guid]::Empty };

# ============================================================
# Invoke-XrmCustomApi
# ============================================================
Write-Section "Invoke-XrmCustomApi";

$response = Invoke-XrmCustomApi -XrmClient $Global:XrmClient -Name $apiName -Parameters @{ Input = "hello" };
Assert-Test "Response: raw JSON output" { $response.Results["Result"] -eq '{"Echo":"hello","Length":5}' };

$result = Invoke-XrmCustomApi -XrmClient $Global:XrmClient -Name $apiName -Parameters @{ Input = "hello" } -JsonOutput "Result";
Assert-Test "-JsonOutput: deserialized object" { $result.Echo -eq "hello" -and $result.Length -eq 5 };

$skipped = Invoke-XrmCustomApi -XrmClient $Global:XrmClient -Name $apiName -Parameters @{ Input = "hello" } -WhatIf;
Assert-Test "-WhatIf: not executed, nothing returned" { $null -eq $skipped };

# ============================================================
# Invoke-XrmCustomApiLoop
# ============================================================
Write-Section "Invoke-XrmCustomApiLoop";

$counter = @{ Calls = 0 };
$seen = [System.Collections.Generic.List[int]]::new();
$loop = Invoke-XrmCustomApiLoop -XrmClient $Global:XrmClient -Name $apiName -Parameters @{ Input = "abc" } -JsonOutput "Result" `
    -OnIteration { param($output, $iteration) $counter.Calls++; $seen.Add($iteration); } -While { $counter.Calls -lt 3 } -MaxIterations 10;
Assert-Test "Stops when -While is false: 3 iterations, no ceiling, last output" { $loop.Iterations -eq 3 -and -not $loop.CeilingReached -and $loop.LastOutput.Echo -eq "abc" };
Assert-Test "-OnIteration receives the iteration number" { ($seen -join ",") -eq "1,2,3" };

$byOutput = Invoke-XrmCustomApiLoop -XrmClient $Global:XrmClient -Name $apiName -Parameters @{ Input = "abc" } -JsonOutput "Result" -While { $_.Length -gt 100 };
Assert-Test "-While reads the output in `$_: 1 iteration" { $byOutput.Iterations -eq 1 -and -not $byOutput.CeilingReached };

$ceiling = Invoke-XrmCustomApiLoop -XrmClient $Global:XrmClient -Name $apiName -Parameters @{ Input = "abc" } -While { $true } -MaxIterations 2;
Assert-Test "Ceiling: 2 iterations, CeilingReached, response as LastOutput" { $ceiling.Iterations -eq 2 -and $ceiling.CeilingReached -and $ceiling.LastOutput.Results["Result"] -like "*abc*" };

$whatIfLoop = Invoke-XrmCustomApiLoop -XrmClient $Global:XrmClient -Name $apiName -While { $true } -MaxIterations 5 -WhatIf;
Assert-Test "-WhatIf: stops after the skipped call" { $whatIfLoop.Iterations -eq 1 -and $null -eq $whatIfLoop.LastOutput -and -not $whatIfLoop.CeilingReached };

$failure = $null;
try { Invoke-XrmCustomApiLoop -XrmClient $Global:XrmClient -Name "new_PdoNoSuchApi$suffix" -While { $true } -MaxIterations 3 | Out-Null; } catch { $failure = $_.Exception.Message; }
Assert-Test "A failed call stops the loop with an error" { $null -ne $failure };

# ============================================================
# Cleanup
# ============================================================
Write-Section "Cleanup";
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "customapi" -Id $apiId; } catch { }
try { Remove-XrmPluginAssembly -XrmClient $Global:XrmClient -Name $assemblyName -Force | Out-Null; } catch { Write-Host "  Cleanup failed: $($_.Exception.Message)" -ForegroundColor Red; }
Remove-Item -Path (Split-Path $assemblyPath -Parent) -Recurse -Force -ErrorAction SilentlyContinue;
Assert-Test "Custom API and assembly removed" {
    $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "customapi" -Id $apiId -IfExists) -and $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "pluginassembly" -Id $assembly.Id -IfExists);
};

Write-TestSummary;
