# Command : `Export-XrmTranslations` 

## Description

**Export the translations of a solution.** : Export the localizable labels of an unmanaged solution (ExportTranslation): a zip file holding CrmTranslations.xml, one column per provisioned language.
The request is synchronous: a large solution can take several minutes.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Unmanaged solution unique name.
ExportPath|String|3|false|[System.IO.Path]::GetTempPath()|Folder where the file is written. (Default: TEMP folder)
Unpack|SwitchParameter|named|false|False|Extract the file into a folder named after it and return the folder path instead of the file path.

## Outputs
System.String. Path of the translation file (CrmTranslations_<SolutionUniqueName>.zip), or of the extracted folder with Unpack.

## Usage

```Powershell 
Export-XrmTranslations [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [[-ExportPath] <String>] [-Unpack] [<CommonParameters>]
``` 

## Examples

```Powershell 
$folder = Export-XrmTranslations -XrmClient $xrmClient -SolutionUniqueName "ContosoCore" -ExportPath "C:\Temp" -Unpack;
[xml]$translations = Get-Content -Path (Join-Path $folder "CrmTranslations.xml") -Raw;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmTranslations.md


