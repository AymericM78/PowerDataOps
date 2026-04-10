# Command : `New-XrmForm` 

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

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created systemform record.

## Usage

```Powershell 
New-XrmForm [[-XrmClient] <ServiceClient>] [[-EntityLogicalName] <String>] [-Name] <String> [-FormXml] <String> [-FormType] <Int32> [[-Description] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = New-XrmForm -EntityLogicalName "account" -Name "Custom Main Form" -FormXml $xml -FormType 2;
$ref = New-XrmForm -Name "Sales Dashboard" -FormXml $xml -FormType 0;
``` 


