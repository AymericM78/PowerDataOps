<#
    Static Test: -WhatIf / -Confirm coverage
    - Invoke-XrmRequest declares SupportsShouldProcess: every write of the module goes through it.
    - A write cmdlet (Add, Set, Remove, Update, Upsert...) that calls a cmdlet declaring SupportsShouldProcess declares it too,
      so that callers can pass -WhatIf to it (preference variables do not flow from a script into a module).
    - No direct SDK write call (Execute, Create, Update, Delete, Associate, Disassociate) outside Invoke-XrmRequest
      and Invoke-XrmParallelRequests (whose workers run where the module is not loaded).
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$srcPath = Join-Path $PSScriptRoot "..\..\src" | Resolve-Path;
$writeVerbs = @("Add", "Set", "Remove", "Update", "Upsert", "Import", "Uninstall", "Publish", "Enable", "Disable", "Copy", "Clear", "Join", "Split", "Merge", "Sync", "Start", "Send", "Share", "Revoke", "Apply", "Backup", "Restore", "Invoke");

$functions = @{};
foreach ($file in Get-ChildItem -Path $srcPath -Recurse -Include "*.ps1") {
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$null, [ref]$null);
    $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true) | ForEach-Object {
        $binding = $_.Body.ParamBlock.Attributes | Where-Object { $_.TypeName.Name -eq "CmdletBinding" };
        $supports = $null -ne ($binding.NamedArguments | Where-Object { $_.ArgumentName -eq "SupportsShouldProcess" });
        $functions[$_.Name] = [PSCustomObject]@{ Name = $_.Name; Ast = $_; Supports = $supports; File = $file.FullName.Substring($srcPath.Path.Length + 1) };
    };
}

Write-Section "Invoke-XrmRequest";
Assert-Test "Invoke-XrmRequest declares SupportsShouldProcess" { $functions["Invoke-XrmRequest"].Supports };

Write-Section "Write cmdlets pass -WhatIf on";
$missing = [System.Collections.Generic.List[string]]::new();
foreach ($function in $functions.Values) {
    $verb = $function.Name.Split("-")[0];
    if ($writeVerbs -notcontains $verb -or $function.Supports -or $function.File -like "_Internals*") {
        continue;
    }
    $calledWriters = $function.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.CommandAst] }, $true) | ForEach-Object { $_.GetCommandName() } | Where-Object { $_ -and $functions.ContainsKey($_) -and $functions[$_].Supports } | Select-Object -Unique;
    if ($calledWriters) {
        $missing.Add("$($function.Name) (calls $($calledWriters -join ', '))");
    }
}
$missing | ForEach-Object { Write-Host "    missing SupportsShouldProcess: $_" -ForegroundColor Yellow; };
Assert-Test "Every write cmdlet calling a ShouldProcess cmdlet declares SupportsShouldProcess ($($missing.Count) missing)" { $missing.Count -eq 0 };

Write-Section "No direct SDK write";
$directCalls = [System.Collections.Generic.List[string]]::new();
foreach ($function in $functions.Values) {
    if ($function.Name -in @("Invoke-XrmRequest", "Invoke-XrmParallelRequests")) {
        continue;
    }
    $function.Ast.FindAll({
            $args[0] -is [System.Management.Automation.Language.InvokeMemberExpressionAst] -and
            -not $args[0].Static -and
            $args[0].Member.Value -in @("Execute", "Create", "Update", "Delete", "Associate", "Disassociate")
        }, $true) | ForEach-Object {
        $directCalls.Add("$($function.File):$($_.Extent.StartLineNumber) $($_.Extent.Text)");
    };
}
$directCalls | ForEach-Object { Write-Host "    direct SDK call: $_" -ForegroundColor Yellow; };
Assert-Test "No direct SDK write outside Invoke-XrmRequest ($($directCalls.Count) found)" { $directCalls.Count -eq 0 };

Write-TestSummary;
