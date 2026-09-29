<#
    Integration Test: ConvertTo-XrmType
    Parsing of bool, numbers and dates: explicit true/false values, culture and exact format.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$invariant = [System.Globalization.CultureInfo]::InvariantCulture;
$french = [System.Globalization.CultureInfo]::GetCultureInfo("fr-FR");

# ============================================================
# bool
# ============================================================
Write-Section "bool";

Assert-Test "'false' is false" { (ConvertTo-XrmType -Type "bool" -Value "false") -eq $false };
Assert-Test "'FALSE' is false (case-insensitive)" { (ConvertTo-XrmType -Type "bool" -Value "FALSE") -eq $false };
Assert-Test "'0' is false" { (ConvertTo-XrmType -Type "bool" -Value "0") -eq $false };
Assert-Test "'no' is false" { (ConvertTo-XrmType -Type "bool" -Value "no") -eq $false };
Assert-Test "'' is false" { (ConvertTo-XrmType -Type "bool" -Value "") -eq $false };
Assert-Test "'true' is true" { (ConvertTo-XrmType -Type "bool" -Value "true") -eq $true };
Assert-Test "' yes ' is true (trimmed)" { (ConvertTo-XrmType -Type "bool" -Value " yes ") -eq $true };
Assert-Test "[bool] `$false stays false" { (ConvertTo-XrmType -Type "bool" -Value $false) -eq $false };
Assert-Test "0 (int) is false" { (ConvertTo-XrmType -Type "bool" -Value 0) -eq $false };

$boolError = $null;
try { ConvertTo-XrmType -Type "bool" -Value "Non" | Out-Null; } catch { $boolError = $_.Exception.Message; }
Assert-Test "Unknown string raises an error listing accepted values" { $boolError -like "*'Non'*true*false*" };

Assert-Test "-TrueValues / -FalseValues: 'Oui' is true" {
    (ConvertTo-XrmType -Type "bool" -Value "Oui" -TrueValues "oui" -FalseValues "non") -eq $true;
};
Assert-Test "-TrueValues / -FalseValues: 'Non' is false" {
    (ConvertTo-XrmType -Type "bool" -Value "Non" -TrueValues "oui" -FalseValues "non") -eq $false;
};

# ============================================================
# Numbers
# ============================================================
Write-Section "decimal / money / int";

Assert-Test "decimal '150.50' with invariant culture" {
    (ConvertTo-XrmType -Type "decimal" -Value "150.50" -Culture $invariant) -eq [decimal]150.50;
};
Assert-Test "decimal '150,50' with fr-FR culture" {
    (ConvertTo-XrmType -Type "decimal" -Value "150,50" -Culture $french) -eq [decimal]150.50;
};
Assert-Test "decimal given as a number is cast, not parsed" {
    (ConvertTo-XrmType -Type "decimal" -Value ([double]1.5) -Culture $french) -eq [decimal]1.5;
};
$money = ConvertTo-XrmType -Type "money" -Value "1234.5" -Culture "en-US";
Assert-Test "money '1234.5' with culture given as a string" {
    $money -is [Microsoft.Xrm.Sdk.Money] -and $money.Value -eq [decimal]1234.5;
};
Assert-Test "int '42'" { (ConvertTo-XrmType -Type "int" -Value "42") -eq 42 };

# ============================================================
# datetime
# ============================================================
Write-Section "datetime";

$date = ConvertTo-XrmType -Type "datetime" -Value "31/12/2026" -Format "dd/MM/yyyy" -Culture $invariant;
Assert-Test "datetime with -Format" {
    $date.Year -eq 2026 -and $date.Month -eq 12 -and $date.Day -eq 31;
};
$date = ConvertTo-XrmType -Type "datetime" -Value "2026-03-04" -Culture $invariant;
Assert-Test "datetime ISO with invariant culture" {
    $date.Month -eq 3 -and $date.Day -eq 4;
};
$now = Get-Date;
Assert-Test "datetime value stays as is" {
    (ConvertTo-XrmType -Type "datetime" -Value $now) -eq $now;
};

Write-TestSummary;
