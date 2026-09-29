# Command : `Get-XrmAppModules` 

## Description

**Retrieve model-driven app records from Microsoft Dataverse.** : Get appmodule records (model-driven apps) with optional name filter.
Use -Unpublished to also retrieve apps that are in draft state.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|false||App display name filter. Optional.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)
Unpublished|SwitchParameter|named|false|False|When specified, uses RetrieveUnpublishedMultiple to include apps that are in draft
(unpublished) state. Without this switch only published apps are returned.
UniqueName|String|4|false||App unique name filter. Optional.
Id|Guid|5|false||App unique identifier filter (appmoduleid). Optional.

## Outputs
PSCustomObject[]. Array of appmodule records (XrmObject).

## Usage

```Powershell 
Get-XrmAppModules [[-XrmClient] <ServiceClient>] [[-Name] <String>] [[-Columns] <String[]>] [-Unpublished] [[-UniqueName] <String>] [[-Id] <Guid>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$apps = Get-XrmAppModules;
$app = Get-XrmAppModules -Name "Sales Hub";
``` 


```Powershell 
# Include unpublished drafts
$allApps = Get-XrmAppModules -Unpublished;
``` 


```Powershell 
$app = Get-XrmAppModules -XrmClient $xrmClient -UniqueName "contoso_sales" -Unpublished -Columns "name";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAppModules.md


