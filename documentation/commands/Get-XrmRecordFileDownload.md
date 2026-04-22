# Command : `Get-XrmRecordFileDownload` 

## Description

**Download a file from a file or image column.** : Download a file stored in a Dataverse file/image column using the InitializeFileBlocksDownload and DownloadBlock SDK messages.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RecordReference|EntityReference|2|true||EntityReference of the record containing the file column.
FileAttributeName|String|3|true||Logical name of the file or image column.
OutputPath|String|4|false||Full file path where the downloaded file will be saved. Optional. If not provided, saves to temp folder with original filename.

## Outputs
System.String. The full path of the downloaded file.

## Usage

```Powershell 
Get-XrmRecordFileDownload [[-XrmClient] <ServiceClient>] [-RecordReference] <EntityReference> [-FileAttributeName] <String> [[-OutputPath] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$filePath = Get-XrmRecordFileDownload -RecordReference $recordRef -FileAttributeName "new_document";
$filePath = Get-XrmRecordFileDownload -RecordReference $recordRef -FileAttributeName "entityimage" -OutputPath "C:\Temp\photo.png";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/file-attributes


