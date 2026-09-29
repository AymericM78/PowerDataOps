# Command : `Set-XrmAttributeValue` 

## Description

**Set entity attribute value.** : Add or update attribute value.
The value is normalized for the SDK: the PowerShell PSObject adapter (objects built with New-Object or emitted by a pipeline) is removed, and a homogeneous Object[] is typed. Without this, the request fails at serialization.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Record|Entity|1|true||Entity record / table row (Entity).
Name|String|2|true||Attribute (Column) name.
Value|Object|3|false||Attribute value object.

## Outputs
Microsoft.Xrm.Sdk.Entity. The updated record, for pipeline chaining.

## Usage

```Powershell 
Set-XrmAttributeValue [-Record] <Entity> [-Name] <String> [[-Value] <Object>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$record = New-XrmEntity -LogicalName "account";
$record = $record | Set-XrmAttributeValue -Name "name" -Value "Contoso";
``` 


