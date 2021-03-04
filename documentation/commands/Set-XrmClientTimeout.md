# Command : `Set-XrmClientTimeout` 

## Description

**Specify CrmserviceClient timeout.** : Extend default CrmserviceClient timeout.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Revert|SwitchParameter|named|false|False|Restore default timeout value.


## Usage

```Powershell 
Set-XrmClientTimeout [[-XrmClient] <CrmServiceClient>] [-Revert] [<CommonParameters>]
``` 


