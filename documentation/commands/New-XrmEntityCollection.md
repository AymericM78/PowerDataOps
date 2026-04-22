# Command : `New-XrmEntityCollection` 

## Description

**Initialize EntityCollection object instance.** : Get new Entity Collection object from entities array.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Entities|Entity[]|1|true||Entities array.

## Outputs
Microsoft.Xrm.Sdk.EntityCollection. The initialized EntityCollection object.

## Usage

```Powershell 
New-XrmEntityCollection [-Entities] <Entity[]> [<CommonParameters>]
``` 

## Examples

```Powershell 
$collection = New-XrmEntityCollection -Entities @($entity1, $entity2);
``` 


