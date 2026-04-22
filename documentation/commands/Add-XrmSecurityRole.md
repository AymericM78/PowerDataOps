# Command : `Add-XrmSecurityRole` 

## Description

**Create a new security role.** : Create a new security role (role) record in Microsoft Dataverse.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Security role display name.
BusinessUnitReference|EntityReference|3|false||Business unit entity reference. Defaults to root business unit if not provided.
Description|String|4|false||Security role description.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created role record.

## Usage

```Powershell 
Add-XrmSecurityRole [[-XrmClient] <ServiceClient>] [-Name] <String> [[-BusinessUnitReference] <EntityReference>] [[-Description] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$roleRef = Add-XrmSecurityRole -Name "Custom Role";
``` 


```Powershell 
$buRef = New-XrmEntityReference -LogicalName "businessunit" -Id $buId;
$roleRef = Add-XrmSecurityRole -Name "Custom Role" -BusinessUnitReference $buRef -Description "Custom role for testing";
``` 


