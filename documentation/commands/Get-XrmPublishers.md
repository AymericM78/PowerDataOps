# Command : `Get-XrmPublishers` 

## Description

**Retrieve publishers.** : Get every publisher of the organization, optionally the custom ones only (publishers created in the organization: not readonly, not the platform ones).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Columns|String[]|2|false|@("publisherid", "uniquename", "friendlyname", "customizationprefix", "customizationoptionvalueprefix", "isreadonly")|Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, customizationprefix, customizationoptionvalueprefix, isreadonly)
CustomOnly|SwitchParameter|named|false|False|Keep the publishers that are not read-only (isreadonly false).

## Outputs
PSCustomObject[]. Publisher rows (XrmObject).

## Usage

```Powershell 
Get-XrmPublishers [[-XrmClient] <ServiceClient>] [[-Columns] <String[]>] [-CustomOnly] [<CommonParameters>]
``` 

## Examples

```Powershell 
Get-XrmPublishers -XrmClient $xrmClient -CustomOnly | Select-Object uniquename, customizationprefix;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPublishers.md


