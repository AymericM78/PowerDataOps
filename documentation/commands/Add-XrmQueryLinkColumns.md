# Command : `Add-XrmQueryLinkColumns` 

## Description

**Add columns to a link entity.** : Add one or more columns to a given link entity for retrieval.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Link|LinkEntity|1|true||LinkEntity where columns should be added.
Columns|String[]|2|true||Array of column / attribute logical names to add.

## Outputs
Microsoft.Xrm.Sdk.Query.LinkEntity. The updated LinkEntity for pipeline chaining.

## Usage

```Powershell 
Add-XrmQueryLinkColumns [-Link] <LinkEntity> [-Columns] <String[]> [<CommonParameters>]
``` 

## Examples

```Powershell 
$link = $query | Add-XrmQueryLink -ToEntityName "contact" -FromAttributeName "contactid" -ToAttributeName "contactid";
$link | Add-XrmQueryLinkColumns -Columns @("fullname", "emailaddress1");
``` 


