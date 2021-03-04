# Command : `Copy-XrmInstance` 

## Description

**Copy instance to another.** : Copy given source instance to target source instance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
SourceInstanceDomainName|String|1|true||Instance domain name (myinstance => myinstance.crm.dynamics1.com) that you want to copy
TargetInstanceDomainName|String|2|true||Instance domain name (myinstance => myinstance.crm.dynamics1.com) that you want to overwrite
CopyType|String|3|true||Copy type : MinimalCopy (schema only) / FullCopy (All)

## Outputs

## Usage

```Powershell 
Copy-XrmInstance [-SourceInstanceDomainName] <String> [-TargetInstanceDomainName] <String> [-CopyType] <String> [<CommonParameters>]
``` 


