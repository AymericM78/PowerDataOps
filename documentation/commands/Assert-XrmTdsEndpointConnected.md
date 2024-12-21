# Command : `Assert-XrmTdsEndpointConnected` 

## Description

**Check if TDS endpoint is enabled.** : Assert orgdbsettings EnableTDSEndpoint parameter is true to allow SQL commands thru TDS Endpoint.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)


## Usage

```Powershell 
Assert-XrmTdsEndpointConnected [[-XrmClient] <CrmServiceClient>] [<CommonParameters>]
``` 


