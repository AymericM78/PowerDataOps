# Command : `Get-XrmDashboards` 

## Description

**Retrieve dashboard records from Microsoft Dataverse.** : Get systemform records filtered to dashboards (type = 0). Delegates to Get-XrmForms.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Columns|String[]|2|false|@("*")|Specify expected columns to retrieve. (Default : all columns)

## Outputs
PSCustomObject[]. Array of systemform records (XrmObject, dashboards).

## Usage

```Powershell 
Get-XrmDashboards [[-XrmClient] <ServiceClient>] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$dashboards = Get-XrmDashboards;
``` 


