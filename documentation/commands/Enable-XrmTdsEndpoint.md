﻿# Command : `Enable-XrmTdsEndpoint` 

## Description

**Enable TDS endpoint.** : Configure orgdbsettings parameter to allow SQL commands thru TDS Endpoint.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)


## Usage

```Powershell 
Enable-XrmTdsEndpoint [[-XrmClient] <CrmServiceClient>] [<CommonParameters>]
``` 


