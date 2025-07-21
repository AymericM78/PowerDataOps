# Command : `Split-XrmCollection` 

## Description

**Split given collection into specified sized collections.** : Extract chunk collections from given one.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Collection|Object|1|false||Input array to split.
Count|Int32|2|true|0|Target collections size.


## Usage

```Powershell 
Split-XrmCollection [[-Collection] <Object>] [-Count] <Int32> [<CommonParameters>]
``` 


