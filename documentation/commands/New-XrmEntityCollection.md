# Command : `New-XrmEntityCollection` 

## Description

**Initialize EntityCollection object instance.** : Get new Entity Collection object from entities array.
The collection is built with its constructor, so it carries no PowerShell PSObject adapter and can be stored as is in an attribute or a request parameter.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Entities|Entity[]|1|false|@()|Entities array. (Default: empty collection)

## Outputs
Microsoft.Xrm.Sdk.EntityCollection. The initialized EntityCollection object.

## Usage

```Powershell 
New-XrmEntityCollection [[-Entities] <Entity[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$collection = New-XrmEntityCollection -Entities @($entity1, $entity2);
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntityCollection.md


