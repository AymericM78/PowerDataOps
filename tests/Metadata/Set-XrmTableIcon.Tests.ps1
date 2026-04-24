<#
    Integration Test: Set-XrmTableIcon cmdlet
    Validates assigning an SVG webresource as the vector icon of a temporary table.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$prefix = 'new';
$tableName = "${prefix}_pdotableicon$(Get-Random -Minimum 10000 -Maximum 99999)";
$tableDisplayName = 'PDO Table Icon Test';
$tableCreated = $false;
$webResource = $null;
$svgFilePath = Join-Path $env:TEMP "$(Get-TestName -Prefix 'TableIcon').svg";
$webResourceName = "new_$(Get-TestName -Prefix 'TableIconResource').svg";

Write-Section 'Create Table';

$createTableResponse = $Global:XrmClient | Add-XrmTable `
    -LogicalName $tableName `
    -DisplayName $tableDisplayName `
    -PluralName "${tableDisplayName}s" `
    -Description 'Integration test table icon' `
    -OwnershipType ([Microsoft.Xrm.Sdk.Metadata.OwnershipTypes]::UserOwned) `
    -PrimaryAttributeSchemaName "${prefix}_name" `
    -PrimaryAttributeDisplayName 'Name' `
    -PrimaryAttributeMaxLength 200;

Assert-Test "Add-XrmTable - created '$tableName'" {
    $createTableResponse -ne $null;
};
$tableCreated = $true;

Write-Section 'Create SVG Webresource';

$svgContent = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><rect width="16" height="16" rx="3" fill="#0F6CBD"/></svg>';
[System.IO.File]::WriteAllText($svgFilePath, $svgContent, [System.Text.UTF8Encoding]::new($false));

$webResource = New-XrmEntity -LogicalName 'webresource' -Attributes @{
    'name' = $webResourceName;
    'displayname' = $webResourceName;
    'content' = (Get-XrmBase64 -FilePath $svgFilePath);
    'webresourcetype' = (New-XrmOptionSetValue -Value 11);
};
$webResource.Id = $Global:XrmClient | Add-XrmRecord -Record $webResource;

Assert-Test 'SVG webresource created' {
    $webResource.Id -ne [Guid]::Empty;
};

Write-Section 'Assign Table Icon';

$updatedMetadata = Set-XrmTableIcon -XrmClient $Global:XrmClient -EntityLogicalName $tableName -WebResourceName $webResourceName -PublishChanges $false;
Assert-Test 'Set-XrmTableIcon returns updated metadata' {
    $updatedMetadata -ne $null -and $updatedMetadata.LogicalName -eq $tableName -and $updatedMetadata.IconVectorName -eq $webResourceName;
};

$refreshedMetadata = $Global:XrmClient | Get-XrmEntityMetadata -LogicalName $tableName -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity);
Assert-Test 'Table IconVectorName updated' {
    $refreshedMetadata.IconVectorName -eq $webResourceName;
};

Write-Section 'Cleanup';

if ($tableCreated) {
    $Global:XrmClient | Remove-XrmTable -LogicalName $tableName | Out-Null;
}
if ($null -ne $webResource -and $webResource.Id -ne [Guid]::Empty) {
    $Global:XrmClient | Remove-XrmRecord -LogicalName 'webresource' -Id $webResource.Id | Out-Null;
}
if (Test-Path $svgFilePath) {
    Remove-Item -Path $svgFilePath -Force;
}

Assert-Test 'Temporary SVG file deleted' {
    -not (Test-Path $svgFilePath);
};

Write-TestSummary;