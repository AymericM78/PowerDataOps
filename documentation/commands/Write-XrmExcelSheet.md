# Command : `Write-XrmExcelSheet` 

## Description

**Write Excel Sheet.** : Push Microsoft Dataverse rows / entity records to Excel file on a specific sheet.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ExcelFilePath|String|1|true||Full path to Excel file.
SheetName|String|2|true||Excel sheet name.
Records|PSObject[]|3|true||Rows / Entity records array.
HeaderMappings|OrderedDictionary|4|true||Key value pair collection that map Excel column name to record column (attribute logicalname)
ColumnsSize|Int32[]|5|false|@()|Array that specify columns width.
TableStyle|String|6|false|TableStyleMedium15|Specify table template name. (Default: TableStyleMedium15)
More information : https://docs.devexpress.com/OfficeFileAPI/DevExpress.Spreadsheet.BuiltInTableStyleId


## Usage

```Powershell 
Write-XrmExcelSheet [-ExcelFilePath] <String> [-SheetName] <String> [-Records] <PSObject[]> [-HeaderMappings] <OrderedDictionary> [[-ColumnsSize] <Int32[]>] 
[[-TableStyle] <String>] [<CommonParameters>]
``` 


