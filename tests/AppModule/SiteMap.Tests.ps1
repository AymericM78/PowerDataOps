<#!
    Integration Test: SiteMap cmdlets
    Validates create, retrieve, update for sitemap.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Create SiteMap";
$name = Get-TestName -Prefix "SiteMap";
$xml = '<SiteMap><Area Id="SFA" ResourceId="Area_Sales" Icon="" ShowGroups="true"/>';
$siteMap = Add-XrmSiteMap -SiteMapName $name -SiteMapXml $xml;
Assert-Test "SiteMap created" { $siteMap -and $siteMap.sitemapid };

Write-Section "Get SiteMaps";
$siteMaps = Get-XrmSiteMaps -Name $name;
Assert-Test "SiteMap found" { $siteMaps.Count -eq 1 -and $siteMaps[0].sitemapid -eq $siteMap.sitemapid };

Write-Section "Update SiteMap";
$newXml = '<SiteMap><Area Id="SFA2" ResourceId="Area_Sales" Icon="" ShowGroups="true"/>';
Set-XrmSiteMap -SiteMapId $siteMap.sitemapid -SiteMapXml $newXml | Out-Null;
$updated = Get-XrmSiteMaps -Name $name | Select-Object -First 1;
Assert-Test "SiteMap updated" { $updated.sitemapxml -like '*SFA2*' };

Write-Section "Cleanup";
Remove-XrmRecord -LogicalName "sitemap" -Id $siteMap.sitemapid | Out-Null;
Write-TestSummary;
