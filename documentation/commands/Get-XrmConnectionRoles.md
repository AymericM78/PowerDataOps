# Command : `Get-XrmConnectionRoles` 

## Description

**Retrieve connection roles from Microsoft Dataverse.** : Get connectionrole records with optional name or category filter.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|false||Connection role name filter. Optional.
Category|Int32|3|false|0|Connection role category value filter. Optional.
Columns|String[]|4|false|@("*")|Specify expected columns to retrieve. (Default : all columns)

## Outputs
PSCustomObject[]. Array of connection role records (XrmObject).

## Usage

```Powershell 
Get-XrmConnectionRoles [[-XrmClient] <ServiceClient>] [[-Name] <String>] [[-Category] <Int32>] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$roles = Get-XrmConnectionRoles;
$roles = Get-XrmConnectionRoles -Name "Stakeholder";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/describe-relationship-entities-connection-roles


