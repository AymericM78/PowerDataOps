# Command : `Remove-XrmDashboard` 

## Description

**Delete a dashboard from Microsoft Dataverse.** : Delete a systemform record (dashboard). Delegates to Remove-XrmForm.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
DashboardReference|EntityReference|2|true||EntityReference of the systemform (dashboard) to delete.

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmDashboard [[-XrmClient] <ServiceClient>] [-DashboardReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmDashboard -DashboardReference $dashRef;
``` 


