# Command : `Update-XrmRecordFileUpload` 

## Description

**Upload a file to an entity record's file attribute field in Microsoft Dataverse.** : Upload a file to a date row's (entity record's) file field from Microsoft Dataverse table.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Record|Entity|2|true||Record (row) to update.
FileAttributeLogicalName|String|3|true||Entity file attribute name.
FilePath|String|4|true||Path to file on the OS file system.


## Usage

```Powershell 
Update-XrmRecordFileUpload [[-XrmClient] <CrmServiceClient>] [-Record] <Entity> [-FileAttributeLogicalName] <String> [-FilePath] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
# Create a new record that has a File attribute with the logical name: new_document
$entityRecord = New-XrmEntity -LogicalName "new_DocumentStore" -Attributes @{
    "name" = "file1";
}
$entityRecord.Id = Add-XrmRecord -Record $entityRecord
Update-XrmRecordFileUpload -XrmClient $XrmClient -Record $entityRecord -FileAttributeLogicalName "new_document" -FilePath 'C:\temp\test.docx'
``` 


