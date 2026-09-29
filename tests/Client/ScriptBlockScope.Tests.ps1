<#
    Static Test: scriptblock scope
    A scriptblock passed to a command (ForEach-ObjectWithProgress, Invoke-XrmQueryPagesInternal, Watch-XrmAsynchOperation...)
    runs in its own scope: there, $PSBoundParameters is the scriptblock one, so a test such as
    $PSBoundParameters.ContainsKey("TopCount") is always false. Read it before the scriptblock.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "PSBoundParameters inside passed scriptblocks";

$srcPath = Join-Path $PSScriptRoot "..\..\src" | Resolve-Path;
$violations = [System.Collections.Generic.List[string]]::new();
foreach ($file in Get-ChildItem -Path $srcPath -Recurse -Include "*.ps1") {
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$null, [ref]$null);
    $blocks = $ast.FindAll({
            $args[0] -is [System.Management.Automation.Language.ScriptBlockExpressionAst] -and
            $args[0].Parent -is [System.Management.Automation.Language.CommandAst] -and
            $args[0].Parent.GetCommandName() -ne "Register-ArgumentCompleter"
        }, $true);
    foreach ($block in $blocks) {
        $block.FindAll({ $args[0] -is [System.Management.Automation.Language.VariableExpressionAst] -and $args[0].VariablePath.UserPath -eq "PSBoundParameters" }, $true) | ForEach-Object {
            $violations.Add("$($file.FullName.Substring($srcPath.Path.Length + 1)):$($_.Extent.StartLineNumber) in a $($block.Parent.GetCommandName()) scriptblock");
        };
    }
}

$violations | ForEach-Object { Write-Host "    $_" -ForegroundColor Yellow; };
Assert-Test "No `$PSBoundParameters read inside a passed scriptblock ($($violations.Count) found)" {
    $violations.Count -eq 0;
};

Write-TestSummary;
