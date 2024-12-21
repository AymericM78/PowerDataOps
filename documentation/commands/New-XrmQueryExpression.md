# Command : `New-XrmQueryExpression` 

## Description

**Return QueryExpression object instance.** : Initialize new query expression object.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Gets or sets the entity name for the condition.
Columns|String[]|2|false||Gets or sets the columns to return in the query results.
TopCount|Int32|3|false|1000|Gets or sets the number of rows to be returned.

## Outputs
Microsoft.Xrm.Sdk.Query.QueryExpression

## Usage

```Powershell 
New-XrmQueryExpression [-LogicalName] <String> [[-Columns] <String[]>] [[-TopCount] <Int32>] [<CommonParameters>]
``` 


