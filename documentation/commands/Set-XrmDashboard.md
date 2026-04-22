# Command : `Set-XrmDashboard` 

## Description

**Update a dashboard in Microsoft Dataverse.** : Update an existing systemform record (dashboard). Delegates to Set-XrmForm.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
DashboardReference|EntityReference|2|true||EntityReference of the systemform (dashboard) to update.
Name|String|3|false||Updated dashboard display name.
FormXml|String|4|false||Updated dashboard form XML definition.
Description|String|5|false||Updated description.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated systemform record.

## Usage

```Powershell 
Set-XrmDashboard [[-XrmClient] <ServiceClient>] [-DashboardReference] <EntityReference> [[-Name] <String>] [[-FormXml] <String>] [[-Description] 
<String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmDashboard -DashboardReference $dashRef -Name "Updated Sales Dashboard";
``` 


