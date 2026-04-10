# Command : `New-XrmDashboard` 

## Description

**Create a new dashboard in Microsoft Dataverse.** : Create a new systemform record of type dashboard (type = 0). Delegates to New-XrmForm.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Dashboard display name.
FormXml|String|3|true||Dashboard form XML definition.
Description|String|4|false||Dashboard description.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created systemform record.

## Usage

```Powershell 
New-XrmDashboard [[-XrmClient] <ServiceClient>] [-Name] <String> [-FormXml] <String> [[-Description] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = New-XrmDashboard -Name "Sales Dashboard" -FormXml $xml;
``` 


