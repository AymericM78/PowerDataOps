# Command : `Invoke-XrmBulkRequests` 

## Description

**Split and Execute Multiple Organization Requests.** : Send requests to Microsoft Dataverse for bulk execution.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Requests|OrganizationRequest[]|2|true||Array of organization requests to execute.
BatchSize|Int32|3|false|500|
ContinueOnError|Boolean|4|false|False|Indicates wether to continue or stop execution if an error occured. (Default: false = Continue)
ReturnResponses|Boolean|5|false|False|Indicates if response are collected for each request execution. (Default: false = No response)
Quiet|SwitchParameter|named|false|False|

## Outputs
System.Collections.ArrayList. Collection of OrganizationResponse objects.

## Usage

```Powershell 
Invoke-XrmBulkRequests [[-XrmClient] <ServiceClient>] [-Requests] <OrganizationRequest[]> [[-BatchSize] <Int32>] [[-ContinueOnError] <Boolean>] 
[[-ReturnResponses] <Boolean>] [-Quiet] [<CommonParameters>]
``` 

## Examples

```Powershell 
$responses = Invoke-XrmBulkRequests -Requests $requests -ReturnResponses $true;
``` 


