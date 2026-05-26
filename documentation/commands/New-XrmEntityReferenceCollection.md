# Command : `New-XrmEntityReferenceCollection` 

## Description

**Initialize EntityReferenceCollection object instance.** : Get new EntityReferenceCollection object from entity references array.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
EntityReferences|EntityReference[]|1|true||Array of EntityReference objects to include in the collection.

## Outputs
Microsoft.Xrm.Sdk.EntityReferenceCollection. The initialized EntityReferenceCollection object.

## Usage

```Powershell 
New-XrmEntityReferenceCollection [-EntityReferences] <EntityReference[]> [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = New-XrmEntityReference -LogicalName "savedquery" -Id $viewId;
$collection = New-XrmEntityReferenceCollection -EntityReferences @($ref);
``` 

## More informations

https://learn.microsoft.com/en-us/dotnet/api/microsoft.xrm.sdk.entityreferencecollection


