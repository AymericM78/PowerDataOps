# Command : `Invoke-XrmRequest` 

## Description

**Execute Organization Request.** : Send request to Microsoft Dataverse for execution.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Request|OrganizationRequest|2|true||Organization request to execute.
Async|SwitchParameter|named|false|False|Indicates if request should be run in background. Request must supports asynchronous execution. (Default: false = run synchronously)

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse

## Usage

```Powershell 
Invoke-XrmRequest [[-XrmClient] <ServiceClient>] [-Request] <OrganizationRequest> [-Async] [<CommonParameters>]
``` 


