# Command : `Read-XrmExcelSheet` 

## Description

**Read Excel Sheet.** : Read a worksheet and return a collection of objects using the header row as property names.
Use -AsArray to keep the legacy raw Excel array behavior.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ExcelFilePath|String|1|true||Full path to Excel file.
SheetName|String|2|true||Excel sheet name.
HeaderRowIndex|Int32|3|false|1|Excel row number that contains the column headers. Default is 1.
AsArray|SwitchParameter|named|false|False|Return the raw Excel value array instead of PSCustomObject rows.

## Outputs
System.Management.Automation.PSObject[]

## Usage

```Powershell 
Read-XrmExcelSheet [-ExcelFilePath] <String> [-SheetName] <String> [[-HeaderRowIndex] <Int32>] [-AsArray] [<CommonParameters>]
``` 


