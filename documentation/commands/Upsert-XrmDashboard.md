# Command : `Upsert-XrmDashboard` 

## Description

**Create or update a dashboard in Microsoft Dataverse.** : Upsert a systemform record of type dashboard (type = 0) by Id. Delegates to Upsert-XrmForm.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|2|true||Dashboard (systemform) Id used as the upsert key.
Name|String|3|true||Dashboard display name.
FormXml|String|4|true||Dashboard form XML definition.
Description|String|5|false||Dashboard description.
SolutionUniqueName|String|6|false||Unmanaged solution unique name. When provided, the dashboard is added to this solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted systemform record.

## Usage

```Powershell 
Upsert-XrmDashboard [[-XrmClient] <ServiceClient>] [-Id] <Guid> [-Name] <String> [-FormXml] <String> [[-Description] <String>] [[-SolutionUniqueName] 
<String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Upsert-XrmDashboard -Id $dashboardId -Name "Sales Dashboard" -FormXml $xml -SolutionUniqueName "MySolution";
``` 


