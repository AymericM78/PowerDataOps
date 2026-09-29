<#
    Static Test: XrmClient propagation
    Every call from a module function to another module function that takes -XrmClient must pass the caller's client:
    otherwise it falls back to $Global:XrmClient, which is empty in a parallel runspace and wrong when a script uses two connections.
    Accepted forms: -XrmClient $x, $XrmClient | Verb-Xrm..., or splatting a hashtable that holds an XrmClient key.
    Not checked: argument completers, and functions that have no client of their own (no XrmClient parameter or variable).
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Parse module sources";

$srcPath = Join-Path $PSScriptRoot "..\..\src" | Resolve-Path;
$files = Get-ChildItem -Path $srcPath -Recurse -Include "*.ps1";
$fileAsts = @{};
$functionsWithClient = @{};
foreach ($file in $files) {
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$null, [ref]$null);
    $fileAsts[$file.FullName] = $ast;
    $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true) | ForEach-Object {
        $paramBlock = $_.Body.ParamBlock;
        if ($paramBlock -and ($paramBlock.Parameters | Where-Object { $_.Name.VariablePath.UserPath -eq "XrmClient" })) {
            $functionsWithClient[$_.Name] = $true;
        }
    };
}
Assert-Test "Module functions with an XrmClient parameter found ($($functionsWithClient.Count))" {
    $functionsWithClient.Count -gt 100;
};

Write-Section "Check internal calls";

$violations = [System.Collections.Generic.List[string]]::new();
foreach ($filePath in $fileAsts.Keys) {
    $commands = $fileAsts[$filePath].FindAll({ $args[0] -is [System.Management.Automation.Language.CommandAst] }, $true);
    foreach ($command in $commands) {
        $name = $command.GetCommandName();
        if (-not $name -or -not $functionsWithClient.ContainsKey($name)) {
            continue;
        }

        # Enclosing function, and skip completers / attributes
        $parent = $command.Parent;
        $enclosingFunction = $null;
        $skip = $false;
        while ($parent) {
            if ($parent -is [System.Management.Automation.Language.AttributeAst]) { $skip = $true; break; }
            if ($parent -is [System.Management.Automation.Language.CommandAst] -and $parent.GetCommandName() -eq "Register-ArgumentCompleter") { $skip = $true; break; }
            if ($parent -is [System.Management.Automation.Language.FunctionDefinitionAst]) { $enclosingFunction = $parent; break; }
            $parent = $parent.Parent;
        }
        if ($skip -or -not $enclosingFunction) {
            continue;
        }
        $functionText = $enclosingFunction.Extent.Text;
        if ($functionText -notmatch '\$XrmClient\b') {
            continue;
        }

        $bound = $command.CommandElements | Where-Object { $_ -is [System.Management.Automation.Language.CommandParameterAst] -and $_.ParameterName -eq "XrmClient" };
        if ($bound) {
            continue;
        }

        $splats = $command.CommandElements | Where-Object { $_ -is [System.Management.Automation.Language.VariableExpressionAst] -and $_.Splatted };
        if ($splats -and $functionText -match '["'']?XrmClient["'']?\s*=\s*\$XrmClient') {
            continue;
        }

        if ($command.Parent -is [System.Management.Automation.Language.PipelineAst]) {
            $index = $command.Parent.PipelineElements.IndexOf($command);
            if ($index -gt 0 -and $command.Parent.PipelineElements[$index - 1].Extent.Text -match '^\$\w*XrmClient$') {
                continue;
            }
        }

        $relativePath = $filePath.Substring($srcPath.Path.Length + 1);
        $violations.Add("$($relativePath):$($command.Extent.StartLineNumber) $name");
    }
}

$violations | ForEach-Object { Write-Host "    missing -XrmClient: $_" -ForegroundColor Yellow; };
Assert-Test "Every internal call passes the caller's XrmClient ($($violations.Count) missing)" {
    $violations.Count -eq 0;
};

Write-Section "Runtime: explicit client with an empty global client";

$client = $Global:XrmClient;
$userId = ($client | Get-XrmWhoAmI);
$Global:XrmClient = $null;
try {
    $user = $client | Get-XrmUser -UserId $userId -Columns "fullname";
    Assert-Test "Get-XrmUser" { $null -ne $user -and $user.Id -eq $userId };

    $roles = @($client | Get-XrmRoles -OnlyRoots -Columns "name");
    Assert-Test "Get-XrmRoles -OnlyRoots" { $roles.Count -gt 0 };

    $privilege = $client | New-XrmRolePrivilege -PrivilegeName "prvReadAccount" -Depth Global;
    Assert-Test "New-XrmRolePrivilege -PrivilegeName" { $null -ne $privilege -and $privilege.PrivilegeId -ne [Guid]::Empty };
}
finally {
    $Global:XrmClient = $client;
}

Write-TestSummary;
