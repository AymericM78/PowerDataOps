# Command : `Disable-XrmTdsEndpoint` 

## Description

**Disable TDS endpoint.** : Configure orgdbsettings parameter to prevent SQL commands thru TDS Endpoint.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)


## Usage

```Powershell 
Disable-XrmTdsEndpoint [[-XrmClient] <ServiceClient>] [<CommonParameters>]
``` 


