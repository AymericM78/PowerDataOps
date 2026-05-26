# Command : `Upsert-XrmForm` 

## Description

**Create or update a form in Microsoft Dataverse.** : Upsert a systemform record by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|2|true||Form (systemform) Id used as the upsert key.
EntityLogicalName|String|3|false||Table / Entity logical name the form belongs to. Optional for dashboards.
Name|String|4|true||Form display name.
FormXml|String|5|true||Form XML definition.
FormType|Int32|6|true|0|Form type (0=Dashboard, 2=Main, 5=Mobile, 6=QuickCreate, 7=QuickView).
Description|String|7|false||Form description.
SolutionUniqueName|String|8|false||Unmanaged solution unique name. When provided, the form is added to this solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted systemform record.

## Usage

```Powershell 
Upsert-XrmForm [[-XrmClient] <ServiceClient>] [-Id] <Guid> [[-EntityLogicalName] <String>] [-Name] <String> [-FormXml] <String> [-FormType] <Int32> 
[[-Description] <String>] [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Upsert-XrmForm -Id $formId -EntityLogicalName "account" -Name "Custom Main Form" -FormXml $xml -FormType 2 -SolutionUniqueName "MySolution";
``` 


