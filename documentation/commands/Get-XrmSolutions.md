# Command : `Get-XrmSolutions` 

## Description

**Retrieve solutions records.** : Get all solutions from instance with expected columns.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Columns|String[]|2|false|@("solutionid", "uniquename", "friendlyname", "version", "ismanaged", "installedon", "createdby", "publisherid", "modifiedon", "modifiedby")|Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, version, ismanaged, installedon, createdby, publisherid, modifiedon, modifiedby)
PublisherId|Guid|3|false||Keep the solutions of this publisher. (Default: all)
VisibleOnly|SwitchParameter|named|false|False|Keep the solutions shown in the maker portal (isvisible true): excludes the system solutions such as Active and Basic.

## Outputs
PSCustomObject[]. Solution rows (XrmObject).

## Usage

```Powershell 
Get-XrmSolutions [[-XrmClient] <ServiceClient>] [[-Columns] <String[]>] [[-PublisherId] <Guid>] [-VisibleOnly] [<CommonParameters>]
``` 

## Examples

```Powershell 
$publisher = Get-XrmPublisher -XrmClient $xrmClient -PublisherUniqueName "contoso";
$solutions = Get-XrmSolutions -XrmClient $xrmClient -PublisherId $publisher.Id -VisibleOnly -Columns "uniquename", "version";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutions.md


