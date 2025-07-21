# Command : `Assert-XrmTdsEndpointEnabled` 

## Description

**Check if TDS endpoint is enabled.** : Assert orgdbsettings EnableTDSEndpoint parameter is true to allow SQL commands thru TDS Endpoint.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)


## Usage

```Powershell 
Assert-XrmTdsEndpointEnabled [[-XrmClient] <ServiceClient>] [<CommonParameters>]
``` 


