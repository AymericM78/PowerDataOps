# Command : `Set-XrmAttributeValue` 

## Description

**Set entity attribute value.** : Add or update attribute value.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Record|Entity|1|true||Entity record / table row (Entity).
Name|String|2|true||Attribute (Column) name.
Value|Object|3|false||

## Outputs
Microsoft.Xrm.Sdk.Entity

## Usage

```Powershell 
Set-XrmAttributeValue [-Record] <Entity> [-Name] <String> [[-Value] <Object>] [<CommonParameters>]
``` 


