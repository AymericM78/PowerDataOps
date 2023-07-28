# Command : `Invoke-XrmBulkRequest` 

## Description

**Execute Multiple Organization Request.** : Send requests to Microsoft Dataverse for bulk execution.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Requests|OrganizationRequest[]|2|true||Array of organization requests to execute.
ContinueOnError|Boolean|3|false|False|Indicates wether to continue or stop execution if an error occured. (Default: false = Continue)
ReturnResponses|Boolean|4|false|False|Indicates if response are collected for each request execution. (Default: false = No response)

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse

## Usage

```Powershell 
Invoke-XrmBulkRequest [[-XrmClient] <CrmServiceClient>] [-Requests] <OrganizationRequest[]> [[-ContinueOnError] <Boolean>] [[-ReturnResponses] <Boolean>] 
[<CommonParameters>]
``` 


