# Command : `Set-XrmDashboard` 

## Description

**Update a dashboard in Microsoft Dataverse.** : Update an existing systemform record (dashboard). Delegates to Set-XrmForm.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
DashboardReference|EntityReference|2|true||EntityReference of the systemform (dashboard) to update.
Name|String|3|false||Updated dashboard display name.
Labels|Hashtable|4|false||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code), and every provided language is persisted as a real translation via SetLocLabels (delegated to Set-XrmForm). -Name takes precedence for the base 'name' if both are provided.
LanguageCode|Int32|5|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
FormXml|String|6|false||Updated dashboard form XML definition.
Description|String|7|false||Updated description.
SolutionUniqueName|String|8|false||Unmanaged solution unique name. When provided, the updated dashboard is automatically added to this solution.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated systemform record.

## Usage

```Powershell 
Set-XrmDashboard [[-XrmClient] <ServiceClient>] [-DashboardReference] <EntityReference> [[-Name] <String>] [[-Labels] <Hashtable>] [[-LanguageCode] <Int32>] [[-FormXml] <String>] [[-Description] <String>] [[-SolutionUniqueName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmDashboard -DashboardReference $dashRef -Name "Updated Sales Dashboard";
Set-XrmDashboard -DashboardReference $dashRef -FormXml $newXml -SolutionUniqueName "MySolution";
``` 


