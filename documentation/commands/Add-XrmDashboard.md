# Command : `Add-XrmDashboard` 

## Description

**Create a new dashboard in Microsoft Dataverse.** : Create a new systemform record of type dashboard: classic (type = 0) by default, interactive experience with FormType 10. Delegates to Add-XrmForm.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|named|true||Dashboard display name.
Labels|Hashtable|named|true||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code), and every provided language is persisted as a real translation via SetLocLabels (delegated to Add-XrmForm). Example: @{ 1033 = "Sales Dashboard"; 1036 = "Tableau de bord des ventes" }
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
FormXml|String|named|true||Dashboard form XML definition.
Description|String|named|false||Dashboard description.
SolutionUniqueName|String|named|false||Unmanaged solution unique name. When provided, the created dashboard is automatically added to this solution.
FormType|Int32|named|false|0|Dashboard type: 0 = classic (default), 10 = interactive experience. It cannot change once the dashboard exists.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created systemform record.

## Usage

```Powershell 
Add-XrmDashboard [-XrmClient <ServiceClient>] -Name <String> [-LanguageCode <Int32>] -FormXml <String> [-Description <String>] [-SolutionUniqueName <String>] [-FormType <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]

Add-XrmDashboard [-XrmClient <ServiceClient>] -Labels <Hashtable> [-LanguageCode <Int32>] -FormXml <String> [-Description <String>] [-SolutionUniqueName <String>] [-FormType <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Add-XrmDashboard -Name "Sales Dashboard" -FormXml $xml;
$ref = Add-XrmDashboard -Name "Sales Dashboard" -FormXml $xml -SolutionUniqueName "MySolution";
``` 


```Powershell 
$ref = Add-XrmDashboard -Labels @{ 1033 = "Sales Dashboard"; 1036 = "Tableau de bord des ventes" } -LanguageCode 1036 -FormXml $xml;
``` 


```Powershell 
$ref = Add-XrmDashboard -Name "Cash follow-up" -FormXml $interactiveXml -FormType 10;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmDashboard.md


