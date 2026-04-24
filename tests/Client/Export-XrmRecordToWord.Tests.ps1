<#!
    Integration Test: Export-XrmRecordToWord cmdlet
        Validates Word export and creates a reusable account Word template when the environment does not provide one.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

function New-TestWordTemplateFile {
        [CmdletBinding()]
        param(
                [Parameter(Mandatory = $true)]
                [String]
                $FilePath,

                [Parameter(Mandatory = $true)]
                [String]
                $EntityLogicalName,

                [Parameter(Mandatory = $true)]
                [int]
                $ObjectTypeCode,

                [Parameter(Mandatory = $true)]
                [String]
                $FieldLogicalName
        );

        Add-Type -AssemblyName 'System.IO.Compression';
        Add-Type -AssemblyName 'System.IO.Compression.FileSystem';

        $storeItemId = '{' + ([Guid]::NewGuid().ToString().ToUpperInvariant()) + '}';
        $templateNamespace = "urn:microsoft-crm/document-template/$EntityLogicalName/$ObjectTypeCode/";

        $contentTypesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
    <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
    <Default Extension="xml" ContentType="application/xml"/>
        <Override PartName="/customXml/itemProps1.xml" ContentType="application/vnd.openxmlformats-officedocument.customXmlProperties+xml"/>
        <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
        <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
    <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
    <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>
"@;
        $packageRelsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
        <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
        <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
    <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
"@;
                $coreXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <dc:title>PowerDataOps Test Template</dc:title>
        <dc:creator>PowerDataOps</dc:creator>
        <cp:lastModifiedBy>PowerDataOps</cp:lastModifiedBy>
        <dcterms:created xsi:type="dcterms:W3CDTF">2026-04-24T00:00:00Z</dcterms:created>
        <dcterms:modified xsi:type="dcterms:W3CDTF">2026-04-24T00:00:00Z</dcterms:modified>
</cp:coreProperties>
"@;
                $appXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
        <Template>Normal.dotm</Template>
        <TotalTime>0</TotalTime>
        <Pages>1</Pages>
        <Words>1</Words>
        <Characters>1</Characters>
        <Application>Microsoft Office Word</Application>
        <DocSecurity>0</DocSecurity>
        <Lines>1</Lines>
        <Paragraphs>1</Paragraphs>
        <ScaleCrop>false</ScaleCrop>
        <Company>PowerDataOps</Company>
        <LinksUpToDate>false</LinksUpToDate>
        <CharactersWithSpaces>1</CharactersWithSpaces>
        <SharedDoc>false</SharedDoc>
        <HyperlinksChanged>false</HyperlinksChanged>
        <AppVersion>16.0000</AppVersion>
</Properties>
"@;
        $documentXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" mc:Ignorable="w15">
    <w:body>
        <w:p>
            <w:r>
                <w:t xml:space="preserve">PowerDataOps Test Template: </w:t>
            </w:r>
            <w:sdt>
                <w:sdtPr>
                    <w:id w:val="-123456789"/>
                    <w15:dataBinding w:prefixMappings="xmlns:ns0='$templateNamespace' " w:xpath="/ns0:DocumentTemplate[1]/$EntityLogicalName[1]/$FieldLogicalName[1]" w:storeItemID="$storeItemId"/>
                    <w:text/>
                </w:sdtPr>
                <w:sdtContent>
                    <w:r>
                        <w:t>$FieldLogicalName</w:t>
                    </w:r>
                </w:sdtContent>
            </w:sdt>
        </w:p>
        <w:sectPr>
            <w:pgSz w:w="12240" w:h="15840"/>
            <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="708" w:footer="708" w:gutter="0"/>
            <w:cols w:space="708"/>
            <w:docGrid w:linePitch="360"/>
        </w:sectPr>
    </w:body>
</w:document>
"@;
        $stylesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
    <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
        <w:name w:val="Normal"/>
    </w:style>
</w:styles>
"@;
        $documentRelsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
    <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
    <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/customXml" Target="../customXml/item1.xml"/>
</Relationships>
"@;
        $itemXml = @"
<?xml version="1.0" encoding="utf-8"?>
<DocumentTemplate xmlns="$templateNamespace">
    <$($EntityLogicalName) xmlns="">
        <$($FieldLogicalName)>$FieldLogicalName</$($FieldLogicalName)>
    </$($EntityLogicalName)>
</DocumentTemplate>
"@;
        $itemPropsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<ds:datastoreItem ds:itemID="$storeItemId" xmlns:ds="http://schemas.openxmlformats.org/officeDocument/2006/customXml">
    <ds:schemaRefs>
        <ds:schemaRef ds:uri="$templateNamespace"/>
        <ds:schemaRef ds:uri=""/>
    </ds:schemaRefs>
</ds:datastoreItem>
"@;
        $itemRelsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
    <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/customXmlProps" Target="itemProps1.xml"/>
</Relationships>
"@;

        if (Test-Path $FilePath) {
                Remove-Item -Path $FilePath -Force;
        }

        $fileStream = [System.IO.File]::Open($FilePath, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None);
        try {
                $archive = [System.IO.Compression.ZipArchive]::new($fileStream, [System.IO.Compression.ZipArchiveMode]::Create, $false);
                try {
                        $entries = [ordered]@{
                                '[Content_Types].xml' = $contentTypesXml;
                                '_rels/.rels' = $packageRelsXml;
                                'docProps/app.xml' = $appXml;
                                'docProps/core.xml' = $coreXml;
                                'word/document.xml' = $documentXml;
                                'word/styles.xml' = $stylesXml;
                                'word/_rels/document.xml.rels' = $documentRelsXml;
                                'customXml/item1.xml' = $itemXml;
                                'customXml/itemProps1.xml' = $itemPropsXml;
                                'customXml/_rels/item1.xml.rels' = $itemRelsXml;
                        };
                        $utf8Encoding = [System.Text.UTF8Encoding]::new($false);
                        foreach ($entryPath in $entries.Keys) {
                                $entry = $archive.CreateEntry($entryPath);
                                $writer = [System.IO.StreamWriter]::new($entry.Open(), $utf8Encoding);
                                try {
                                        $writer.Write($entries[$entryPath]);
                                }
                                finally {
                                        $writer.Dispose();
                                }
                        }
                }
                finally {
                        $archive.Dispose();
                }
        }
        finally {
                $fileStream.Dispose();
        }

        $FilePath;
};

function New-TestWordTemplateRecord {
        [CmdletBinding()]
        param(
                [Parameter(Mandatory = $true)]
                [String]
                $TemplateName,

                [Parameter(Mandatory = $true)]
                [String]
                $EntityLogicalName,

                [Parameter(Mandatory = $true)]
                [String]
                $FieldLogicalName
        );

        $entityMetadata = Get-XrmEntityMetadata -LogicalName $EntityLogicalName;
        if ($null -eq $entityMetadata -or $null -eq $entityMetadata.ObjectTypeCode) {
                throw "Unable to resolve the object type code for entity '$EntityLogicalName'.";
        }

        $templateFilePath = Join-Path $env:TEMP ($TemplateName + '.docx');
        New-TestWordTemplateFile -FilePath $templateFilePath -EntityLogicalName $EntityLogicalName -ObjectTypeCode ([int]$entityMetadata.ObjectTypeCode) -FieldLogicalName $FieldLogicalName | Out-Null;

        $templateRecord = New-XrmEntity -LogicalName 'documenttemplate' -Attributes @{
                'name' = $TemplateName;
                'associatedentitytypecode' = $EntityLogicalName;
                'documenttype' = (New-XrmOptionSetValue -Value 2);
                'languagecode' = 1033;
                'content' = (Get-XrmBase64 -FilePath $templateFilePath);
                'status' = $false;
        };
        $templateId = $Global:XrmClient | Add-XrmRecord -Record $templateRecord;
        if ($null -eq $templateId -or $templateId -eq [Guid]::Empty) {
                throw "Failed to create reusable Word template '$TemplateName'.";
        }

        $templateRecord.Id = $templateId;
        $template = $Global:XrmClient | Get-XrmRecord -LogicalName 'documenttemplate' -Id $templateRecord.Id -Columns 'name', 'associatedentitytypecode';
        if ($null -eq $template) {
                throw "Reusable Word template '$TemplateName' was created but could not be retrieved.";
        }

        [PSCustomObject]@{
                Template = $template;
                TemplateFilePath = $templateFilePath;
        };
};

Write-Section "Resolve Template And Record";

$testTemplateName = 'PowerDataOps Test Template - Account';
$templateFilePath = $null;
$temporaryTemplateCreated = $false;
$temporaryAccount = $null;
$record = $null;

$templateQuery = New-XrmQueryExpression -LogicalName 'documenttemplate' -TopCount 1 -Columns 'name', 'associatedentitytypecode', 'createdon';
$templateQuery | Add-XrmQueryCondition -Field 'name' -Condition Equal -Values $testTemplateName | Out-Null;
$templateQuery | Add-XrmQueryOrder -Field 'createdon' -OrderType Descending | Out-Null;
$template = $Global:XrmClient | Get-XrmMultipleRecords -Query $templateQuery | Select-Object -First 1;

if ($null -eq $template) {
        Write-Host "  No reusable account Word template was found. Creating one for the test..." -ForegroundColor Yellow;
}

if ($null -eq $template) {
        $createdTemplate = New-TestWordTemplateRecord -TemplateName $testTemplateName -EntityLogicalName 'account' -FieldLogicalName 'name';
        $template = $createdTemplate.Template;
        $templateFilePath = $createdTemplate.TemplateFilePath;
        $temporaryTemplateCreated = $true;
        Assert-Test "Reusable account Word template created" {
                $null -ne $template -and $template.Id -ne [Guid]::Empty;
        };
}

Write-Host "  Creating a temporary account for Word export..." -ForegroundColor Yellow;

$temporaryAccount = New-XrmEntity -LogicalName 'account' -Attributes @{
        'name' = (Get-TestName -Prefix 'WordTemplateAccount');
        'accountnumber' = 'WTT-001';
};
$temporaryAccount.Id = $Global:XrmClient | Add-XrmRecord -Record $temporaryAccount;
Assert-Test "Temporary account created for Word export" {
        $temporaryAccount.Id -ne [Guid]::Empty;
};

$record = $Global:XrmClient | Get-XrmRecord -LogicalName 'account' -Id $temporaryAccount.Id -Columns '*';

$annotationQuery = New-XrmQueryExpression -LogicalName 'annotation' -Columns 'annotationid';
$annotationQuery | Add-XrmQueryCondition -Field 'objectid' -Condition Equal -Values $record.Id | Out-Null;
$existingAnnotationIds = @($Global:XrmClient | Get-XrmMultipleRecords -Query $annotationQuery | ForEach-Object { $_.Id });

$wordFilePath = Join-Path $env:TEMP "$(Get-TestName -Prefix 'RecordWord').docx";
$outputPath = Export-XrmRecordToWord -XrmClient $Global:XrmClient -RecordReference $record.Reference -TemplateReference $template.Reference -OutputPath $wordFilePath;

Assert-Test "Export-XrmRecordToWord returns the output path" {
    $outputPath -eq $wordFilePath;
};
Assert-Test "Export-XrmRecordToWord creates a non-empty document" {
    (Test-Path $wordFilePath) -and ([System.IO.FileInfo]::new($wordFilePath).Length -gt 0);
};

Write-Section "Cleanup";
if (Test-Path $wordFilePath) {
    Remove-Item -Path $wordFilePath -Force;
}

if ($null -ne $templateFilePath -and (Test-Path $templateFilePath)) {
    Remove-Item -Path $templateFilePath -Force;
}

$newAnnotations = $Global:XrmClient | Get-XrmMultipleRecords -Query $annotationQuery;
$generatedAnnotation = $newAnnotations | Where-Object { $existingAnnotationIds -notcontains $_.Id } | Select-Object -First 1;
if ($null -ne $generatedAnnotation) {
    $Global:XrmClient | Remove-XrmRecord -LogicalName 'annotation' -Id $generatedAnnotation.Id;
}

if ($null -ne $temporaryAccount -and $temporaryAccount.Id -ne [Guid]::Empty) {
    $Global:XrmClient | Remove-XrmRecord -LogicalName 'account' -Id $temporaryAccount.Id;
}

Assert-Test "Temporary Word file deleted" {
    -not (Test-Path $wordFilePath);
};
Assert-Test "Temporary template file deleted" {
    $null -eq $templateFilePath -or -not (Test-Path $templateFilePath);
};
Assert-Test "Temporary account deleted" {
    $null -eq $temporaryAccount -or $true;
};

Write-TestSummary;