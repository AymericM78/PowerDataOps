# Command : `Get-XrmPluginTraces` 

## Description

**Retrieve plugin traces.** : Get latest plugin trace log from target instance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
ErrorsOnly|Boolean|2|false|False|
Take|Int32|3|false|50|Specify number of items to retrieve. (Default : 50)


## Usage

```Powershell 
Get-XrmPluginTraces [[-XrmClient] <ServiceClient>] [[-ErrorsOnly] <Boolean>] [[-Take] <Int32>] [<CommonParameters>]
``` 


