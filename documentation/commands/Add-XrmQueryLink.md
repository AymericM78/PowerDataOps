# Command : `Add-XrmQueryLink` 

## Description

**Add link entity to given query expression.** : Add new link to given query expression to join to another table / entity.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Query|QueryExpression|1|true||QueryExpression where condition should be add.
FromAttributeName|String|2|true||Gets or sets the logical name of the attribute of the entity that you are linking from.
ToEntityName|String|3|true||Gets or sets the logical name of the entity that you are linking to.
ToAttributeName|String|4|false||Gets or sets the logical name of the attribute of the entity that you are linking to.
Alias|String|5|false||
JoinOperator|JoinOperator|6|false|Inner|

## Outputs
Microsoft.Xrm.Sdk.Query.LinkEntity

## Usage

```Powershell 
Add-XrmQueryLink [-Query] <QueryExpression> [-FromAttributeName] <String> [-ToEntityName] <String> [[-ToAttributeName] 
<String>] [[-Alias] <String>] [[-JoinOperator] {Inner | LeftOuter | Natural | MatchFirstRowUsingCrossApply | In | 
Exists | Any | NotAny | All | NotAll}] [<CommonParameters>]
``` 


