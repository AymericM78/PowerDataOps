# Command : `Watch-XrmOperation` 

## Description

**Monitor operation completion.** : Poll operation status from given url until its done.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
OperationUrl|String|1|true||Operation Url provided when admin operation is invoked.
PollingIntervalSeconds|Int32|2|false|5|Delay between each status check.


## Usage

```Powershell 
Watch-XrmOperation [-OperationUrl] <String> [[-PollingIntervalSeconds] <Int32>] [<CommonParameters>]
``` 


