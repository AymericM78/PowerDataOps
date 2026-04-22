# Command : `Get-XrmAppModules` 

## Description

**Retrieve model-driven app records from Microsoft Dataverse.** : Get appmodule records (model-driven apps) with optional name filter.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|false||App display name filter. Optional.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)

## Outputs
PSCustomObject[]. Array of appmodule records (XrmObject).

## Usage

```Powershell 
Get-XrmAppModules [[-XrmClient] <ServiceClient>] [[-Name] <String>] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$apps = Get-XrmAppModules;
$app = Get-XrmAppModules -Name "Sales Hub";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code


