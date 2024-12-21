# Command : `Add-XrmQueryOrder` 

## Description

**Add order to query expression.** : Set sort order to query expression.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Query|QueryExpression|1|true||QueryExpression where sort should be add.
Field|String|2|true||Column / attribute logical name to sort.
OrderType|OrderType|3|true||Specify order on given column : ascending or descending.

## Outputs
Microsoft.Xrm.Sdk.Query.QueryExpression

## Usage

```Powershell 
Add-XrmQueryOrder [-Query] <QueryExpression> [-Field] <String> [-OrderType] {Ascending | Descending} [<CommonParameters>]
``` 


