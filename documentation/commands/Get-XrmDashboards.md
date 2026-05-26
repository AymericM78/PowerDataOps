# Command : `Get-XrmDashboards` 

## Description

**Retrieve dashboard records from Microsoft Dataverse.** : Get systemform records filtered to dashboards (type = 0). Delegates to Get-XrmForms.
Use -Unpublished to also retrieve dashboards that are in draft state.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Columns|String[]|2|false|@("*")|Specify expected columns to retrieve. (Default : all columns)
Unpublished|SwitchParameter|named|false|False|When specified, uses RetrieveUnpublishedMultiple to include dashboards in draft (unpublished) state.
Without this switch only published dashboards are returned.

## Outputs
PSCustomObject[]. Array of systemform records (XrmObject, dashboards).

## Usage

```Powershell 
Get-XrmDashboards [[-XrmClient] <ServiceClient>] [[-Columns] <String[]>] [-Unpublished] [<CommonParameters>]
``` 

## Examples

```Powershell 
$dashboards = Get-XrmDashboards;
``` 


```Powershell 
# Include unpublished drafts
$allDashboards = Get-XrmDashboards -Unpublished;
``` 


