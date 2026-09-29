# Command : `Upsert-XrmForm` 

## Description

**Create or update a form in Microsoft Dataverse.** : Upsert a systemform record by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|named|true||Form (systemform) Id used as the upsert key.
EntityLogicalName|String|named|false||Table / Entity logical name the form belongs to. Optional for dashboards.
Name|String|named|true||Form display name.
Labels|Hashtable|named|true||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). Example: @{ 1033 = "Main Form"; 1036 = "Formulaire principal" }
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
FormXml|String|named|true||Form XML definition.
FormType|Int32|named|true|0|Form type (0=Dashboard, 2=Main, 5=Mobile, 6=QuickCreate, 7=QuickView).
Description|String|named|false||Form description.
SolutionUniqueName|String|named|false||Unmanaged solution unique name. When provided, the form is added to this solution.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted systemform record.

## Usage

```Powershell 
Upsert-XrmForm [-XrmClient <ServiceClient>] -Id <Guid> [-EntityLogicalName <String>] -Name <String> [-LanguageCode <Int32>] -FormXml <String> -FormType <Int32> [-Description <String>] [-SolutionUniqueName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]

Upsert-XrmForm [-XrmClient <ServiceClient>] -Id <Guid> [-EntityLogicalName <String>] -Labels <Hashtable> [-LanguageCode <Int32>] -FormXml <String> -FormType <Int32> [-Description <String>] [-SolutionUniqueName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Upsert-XrmForm -Id $formId -EntityLogicalName "account" -Name "Custom Main Form" -FormXml $xml -FormType 2 -SolutionUniqueName "MySolution";
``` 


