<#
    Integration Test: solution component types (brief S01)
    Get-XrmSolutionComponentType (organization first, classic table as fallback) and Get-XrmSolutionComponentName fallback.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Get-XrmSolutionComponentType";

$definitionQuery = New-XrmQueryExpression -LogicalName "solutioncomponentdefinition" -Columns "solutioncomponenttype", "name" | Add-XrmQueryCondition -Field "primaryentityname" -Condition Equal -Values "connectionreference";
$definition = Get-XrmMultipleRecords -XrmClient $Global:XrmClient -Query $definitionQuery -AsEntity | Select-Object -First 1;
$expectedConnectionReferenceType = [int]$definition["solutioncomponenttype"];

Assert-Test "connectionreference: code of the organization ($expectedConnectionReferenceType)" {
    (Get-XrmSolutionComponentType -XrmClient $Global:XrmClient -LogicalName "connectionreference") -eq $expectedConnectionReferenceType;
};
Assert-Test "environmentvariabledefinition: 380" { (Get-XrmSolutionComponentType -XrmClient $Global:XrmClient -LogicalName "environmentvariabledefinition") -eq 380 };
Assert-Test "savedquery (not in solutioncomponentdefinition): 26 from the classic table" { (Get-XrmSolutionComponentType -XrmClient $Global:XrmClient -LogicalName "savedquery") -eq 26 };
Assert-Test "-Name 'SavedQuery': 26" { (Get-XrmSolutionComponentType -XrmClient $Global:XrmClient -Name "SavedQuery") -eq 26 };
Assert-Test "-Name of a solution-aware table: organization code" { (Get-XrmSolutionComponentType -XrmClient $Global:XrmClient -Name $definition["name"]) -eq $expectedConnectionReferenceType };

$unknownError = $null;
try { Get-XrmSolutionComponentType -XrmClient $Global:XrmClient -LogicalName "pdo_nosuchtable" | Out-Null; } catch { $unknownError = $_.Exception.Message; }
Assert-Test "Unknown table raises an error" { $unknownError -like "*pdo_nosuchtable*" };

$cache = @{};
Get-XrmSolutionComponentType -XrmClient $Global:XrmClient -LogicalName "connectionreference" -Cache $cache | Out-Null;
Get-XrmSolutionComponentType -XrmClient $Global:XrmClient -LogicalName "savedquery" -Cache $cache | Out-Null;
Assert-Test "-Cache: filled by the caller's hashtable" { $cache.Count -eq 2 -and $cache["logicalname|connectionreference"] -eq $expectedConnectionReferenceType };

Write-Section "Get-XrmSolutionComponentName";
Assert-Test "Classic type without client: 26 => SavedQuery" { (Get-XrmSolutionComponentName -SolutionComponentType 26) -eq "SavedQuery" };
Assert-Test "Organization type: name from solutioncomponentdefinition (was 'Unknown solution component type')" {
    (Get-XrmSolutionComponentName -XrmClient $Global:XrmClient -SolutionComponentType $expectedConnectionReferenceType) -eq $definition["name"];
};

Write-TestSummary;
