# Command : `Add-XrmForm` 

## Description

**Create a new form in Microsoft Dataverse.** : Create a new systemform record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|named|false||Table / Entity logical name the form belongs to. Optional for dashboards.
Name|String|named|true||Form display name.
Labels|Hashtable|named|true||Hashtable of language code to display name. Alternative to -Name. The stored 'name' attribute is resolved from -LanguageCode (fallback: lowest language code), and every provided language is persisted as a real translation via SetLocLabels so each user sees the label in their own language. Example: @{ 1033 = "Main Form"; 1036 = "Formulaire principal" }
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
FormXml|String|named|true||Form XML definition.
FormType|Int32|named|true|0|Form type (2=Main, 5=Mobile, 6=QuickCreate, 7=QuickView).
Description|String|named|false||Form description.
SourceReference|EntityReference|named|false||EntityReference of an existing systemform to initialize from using the InitializeFrom SDK message.
When provided, the new form is pre-populated with values from the source form, then overridden by provided parameters.
SolutionUniqueName|String|named|false||Unmanaged solution unique name. When provided, the created form is automatically added to this solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created systemform record.

## Usage

```Powershell 
Add-XrmForm [-XrmClient <ServiceClient>] [-EntityLogicalName <String>] -Name <String> [-LanguageCode <Int32>] -FormXml <String> -FormType <Int32> 
[-Description <String>] [-SourceReference <EntityReference>] [-SolutionUniqueName <String>] [<CommonParameters>]

Add-XrmForm [-XrmClient <ServiceClient>] [-EntityLogicalName <String>] -Labels <Hashtable> [-LanguageCode <Int32>] -FormXml <String> -FormType <Int32> 
[-Description <String>] [-SourceReference <EntityReference>] [-SolutionUniqueName <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Add-XrmForm -EntityLogicalName "account" -Name "Custom Main Form" -FormXml $xml -FormType 2;
$ref = Add-XrmForm -Name "Sales Dashboard" -FormXml $xml -FormType 0;
``` 


```Powershell 
$sourceRef = New-XrmEntityReference -LogicalName "systemform" -Id $existingFormId;
$ref = Add-XrmForm -SourceReference $sourceRef -Name "Copied Form" -FormXml $xml -FormType 2 -SolutionUniqueName "MySolution";
``` 


```Powershell 
$ref = Add-XrmForm -EntityLogicalName "account" -Labels @{ 1033 = "Main Form"; 1036 = "Formulaire principal" } -LanguageCode 1036 -FormXml $xml -FormType 2;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/initializefrom


