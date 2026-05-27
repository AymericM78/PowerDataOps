# Command : `Upsert-XrmDashboard` 

## Description

**Create or update a dashboard in Microsoft Dataverse.** : Upsert a systemform record of type dashboard (type = 0) by Id. Delegates to Upsert-XrmForm.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|named|true||Dashboard (systemform) Id used as the upsert key.
Name|String|named|true||Dashboard display name.
Labels|Hashtable|named|true||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). Example: @{ 1033 = "Sales Dashboard"; 1036 = "Tableau de bord des ventes" }
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
FormXml|String|named|true||Dashboard form XML definition.
Description|String|named|false||Dashboard description.
SolutionUniqueName|String|named|false||Unmanaged solution unique name. When provided, the dashboard is added to this solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted systemform record.

## Usage

```Powershell 
Upsert-XrmDashboard [-XrmClient <ServiceClient>] -Id <Guid> -Name <String> [-LanguageCode <Int32>] -FormXml <String> [-Description <String>] 
[-SolutionUniqueName <String>] [<CommonParameters>]

Upsert-XrmDashboard [-XrmClient <ServiceClient>] -Id <Guid> -Labels <Hashtable> [-LanguageCode <Int32>] -FormXml <String> [-Description <String>] 
[-SolutionUniqueName <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Upsert-XrmDashboard -Id $dashboardId -Name "Sales Dashboard" -FormXml $xml -SolutionUniqueName "MySolution";
``` 


