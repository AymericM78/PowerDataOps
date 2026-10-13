# Command : `Split-XrmCollection` 

## Description

**Split given collection into specified sized collections.** : Extract chunk collections from given one.
The collection is given with -Collection or through the pipeline (one element at a time): the chunks are written once every element is read.
Each chunk is written as one array, the last one may be smaller, and a collection smaller than Count gives one chunk. Pipe the result (| ForEach-Object) or collect it with @() to get the list of chunks.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Collection|Object|1|false||Input array to split, or one element when piped.
Count|Int32|2|true|0|Target collections size.

## Outputs
System.Object[]. One array per chunk.

## Usage

```Powershell 
Split-XrmCollection [[-Collection] <Object>] [-Count] <Int32> [<CommonParameters>]
``` 

## Examples

```Powershell 
$chunks = @(Split-XrmCollection -Collection $requests -Count 1000);
foreach ($chunk in $chunks) { Invoke-XrmBulkRequests -Requests $chunk; }
``` 


```Powershell 
$requests | Split-XrmCollection -Count 1000 | ForEach-Object { Invoke-XrmBulkRequests -Requests $_; }
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Split-XrmCollection.md


