# Command : `Add-XrmConnectionRole` 

## Description

**Create a new connection role in Microsoft Dataverse.** : Create a connectionrole record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Connection role display name.
Category|Int32|3|false|0|Connection role category value. Optional. (e.g. 1=Business, 2=Family, 3=Social, 4=Sales, 5=Other, 1000=Stakeholder, 1001=Sales Team, 1002=Service)
Description|String|4|false||Connection role description. Optional.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created connectionrole record.

## Usage

```Powershell 
Add-XrmConnectionRole [[-XrmClient] <ServiceClient>] [-Name] <String> [[-Category] <Int32>] [[-Description] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$roleRef = Add-XrmConnectionRole -Name "Project Manager" -Category 1;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/describe-relationship-entities-connection-roles


