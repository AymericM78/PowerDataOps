# Command : `Add-XrmForm` 

## Description

**Create a new form in Microsoft Dataverse.** : Create a new systemform record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|false||Table / Entity logical name the form belongs to. Optional for dashboards.
Name|String|3|true||Form display name.
FormXml|String|4|true||Form XML definition.
FormType|Int32|5|true|0|Form type (2=Main, 5=Mobile, 6=QuickCreate, 7=QuickView).
Description|String|6|false||Form description.
SourceReference|EntityReference|7|false||EntityReference of an existing systemform to initialize from using the InitializeFrom SDK message.
When provided, the new form is pre-populated with values from the source form, then overridden by provided parameters.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created systemform record.

## Usage

```Powershell 
Add-XrmForm [[-XrmClient] <ServiceClient>] [[-EntityLogicalName] <String>] [-Name] <String> [-FormXml] <String> [-FormType] <Int32> [[-Description] 
<String>] [[-SourceReference] <EntityReference>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Add-XrmForm -EntityLogicalName "account" -Name "Custom Main Form" -FormXml $xml -FormType 2;
$ref = Add-XrmForm -Name "Sales Dashboard" -FormXml $xml -FormType 0;
``` 


```Powershell 
$sourceRef = New-XrmEntityReference -LogicalName "systemform" -Id $existingFormId;
$ref = Add-XrmForm -SourceReference $sourceRef -Name "Copied Form" -FormXml $xml -FormType 2;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/initializefrom


