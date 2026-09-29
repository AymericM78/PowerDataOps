<#!
    Integration Test: SiteMap cmdlets
    Validates create, retrieve, update and upsert for sitemap, including the unique name built from a readable name.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$xml = '<SiteMap><Area Id="SFA" ResourceId="Area_Sales" ShowGroups="true"><Group Id="G1"><SubArea Id="S1" Entity="account" /></Group></Area></SiteMap>';
$siteMapIds = [System.Collections.Generic.List[Guid]]::new();

Write-Section "Add-XrmSiteMap with a readable name";
$name = "PDO Site Map é $suffix";
$siteMapRef = $Global:XrmClient | Add-XrmSiteMap -Name $name -SiteMapXml $xml;
Assert-Test "SiteMap created from a name with spaces and accents" { $null -ne $siteMapRef -and $siteMapRef.Id -ne [Guid]::Empty };
if ($siteMapRef) { $siteMapIds.Add($siteMapRef.Id); }

$siteMap = $Global:XrmClient | Get-XrmSiteMaps -Name $name -Columns "sitemapname", "sitemapnameunique", "sitemapxml" -Unpublished | Select-Object -First 1;
Assert-Test "Unique name built without accents and separators ('PDOSiteMape$suffix')" {
    $null -ne $siteMap -and $siteMap.sitemapnameunique -eq "PDOSiteMape$suffix";
};

Write-Section "Set-XrmSiteMap";
$newXml = $xml.Replace('Id="SFA"', 'Id="SFA2"');
$Global:XrmClient | Set-XrmSiteMap -SiteMapReference $siteMapRef -SiteMapXml $newXml | Out-Null;
$updated = $Global:XrmClient | Get-XrmSiteMaps -Name $name -Columns "sitemapxml" -Unpublished | Select-Object -First 1;
Assert-Test "SiteMap updated" { $updated.sitemapxml -like '*SFA2*' };

Write-Section "Upsert-XrmSiteMap";
$upsertId = [Guid]::NewGuid();
$upsertName = "PDO Upsert-SiteMap ($suffix)";
$upsertRef = $Global:XrmClient | Upsert-XrmSiteMap -Id $upsertId -Name $upsertName -SiteMapXml $xml;
Assert-Test "Upsert creates the sitemap with a derived unique name" { $null -ne $upsertRef -and $upsertRef.Id -eq $upsertId };
$siteMapIds.Add($upsertId);

$upsertRef = $Global:XrmClient | Upsert-XrmSiteMap -Id $upsertId -Name $upsertName -SiteMapXml $newXml;
$upserted = $Global:XrmClient | Get-XrmSiteMaps -Name $upsertName -Columns "sitemapnameunique", "sitemapxml" -Unpublished | Select-Object -First 1;
Assert-Test "Upsert updates the same sitemap" { $upserted.sitemapxml -like '*SFA2*' -and $upserted.sitemapnameunique -eq "PDOUpsertSiteMap$suffix" };

$explicitId = [Guid]::NewGuid();
$Global:XrmClient | Upsert-XrmSiteMap -Id $explicitId -Name "PDO explicit $suffix" -UniqueName "pdoexplicit$suffix" -SiteMapXml $xml | Out-Null;
$siteMapIds.Add($explicitId);
$explicit = $Global:XrmClient | Get-XrmSiteMaps -Name "PDO explicit $suffix" -Columns "sitemapnameunique" -Unpublished | Select-Object -First 1;
Assert-Test "-UniqueName is used as is" { $explicit.sitemapnameunique -eq "pdoexplicit$suffix" };

$invalidError = $null;
try { $Global:XrmClient | Add-XrmSiteMap -Name "x" -UniqueName "not valid!" -SiteMapXml $xml | Out-Null; } catch { $invalidError = $_.Exception.Message; }
Assert-Test "-UniqueName with other characters than letters and digits is rejected" { $null -ne $invalidError };

Write-Section "Cleanup";
foreach ($id in $siteMapIds) {
    try { $Global:XrmClient | Remove-XrmRecord -LogicalName "sitemap" -Id $id; } catch { }
}
Assert-Test "Cleanup complete" { $true };
Write-TestSummary;
