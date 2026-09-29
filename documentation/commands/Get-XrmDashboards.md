# Command : `Get-XrmDashboards` 

## Description

**Retrieve dashboard records from Microsoft Dataverse.** : Get systemform records filtered to dashboards: classic dashboards (type = 0) and interactive experience dashboards (type = 10). Delegates to Get-XrmForms.
Use -Unpublished to also retrieve dashboards that are in draft state.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Columns|String[]|2|false|@("*")|Specify expected columns to retrieve. (Default : all columns)
Unpublished|SwitchParameter|named|false|False|When specified, uses RetrieveUnpublishedMultiple to include dashboards in draft (unpublished) state.
Without this switch only published dashboards are returned.
Type|Int32[]|3|false|@(0, 10)|Dashboard types to return: 0 (classic dashboard), 10 (interactive experience dashboard). (Default: both)

## Outputs
PSCustomObject[]. Array of systemform records (XrmObject, dashboards).

## Usage

```Powershell 
Get-XrmDashboards [[-XrmClient] <ServiceClient>] [[-Columns] <String[]>] [-Unpublished] [[-Type] <Int32[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$dashboards = Get-XrmDashboards;
``` 


```Powershell 
# Include unpublished drafts
$allDashboards = Get-XrmDashboards -Unpublished;
``` 


```Powershell 
# Classic dashboards only
$classicDashboards = Get-XrmDashboards -Type 0;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmDashboards.md


