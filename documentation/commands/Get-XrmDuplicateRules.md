# Command : `Get-XrmDuplicateRules` 

## Description

**Retrieve duplicate detection rules from Microsoft Dataverse.** : Get duplicaterule records with optional entity filter.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|false||Base entity logical name to filter rules. Optional.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)

## Outputs
PSCustomObject[]. Array of duplicate rule records (XrmObject).

## Usage

```Powershell 
Get-XrmDuplicateRules [[-XrmClient] <ServiceClient>] [[-EntityLogicalName] <String>] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$rules = Get-XrmDuplicateRules;
$rules = Get-XrmDuplicateRules -EntityLogicalName "account";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/detect-duplicate-data-with-code


