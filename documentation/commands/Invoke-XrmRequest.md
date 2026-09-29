# Command : `Invoke-XrmRequest` 

## Description

**Execute Organization Request.** : Send request to Microsoft Dataverse for execution.
Supports -WhatIf and -Confirm for the requests that write: a read request (Retrieve*, WhoAmI, Export*...) always runs, a write request runs only if ShouldProcess allows it (with -WhatIf, it is skipped and $null is returned).
Every write of the module goes through this cmdlet, so -WhatIf given to any module cmdlet reaches the writes it makes.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Request|OrganizationRequest|2|true||Organization request to execute.
Async|SwitchParameter|named|false|False|Indicates if request should be run in background. Request must supports asynchronous execution. (Default: false = run synchronously)
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The response ($null when a write is skipped by -WhatIf).

## Usage

```Powershell 
Invoke-XrmRequest [[-XrmClient] <ServiceClient>] [-Request] <OrganizationRequest> [-Async] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$response = $xrmClient | Invoke-XrmRequest -Request (New-XrmRequest -Name "WhoAmI");
``` 


```Powershell 
# Show what would be written, without writing
$xrmClient | Invoke-XrmRequest -Request $deleteRequest -WhatIf;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmRequest.md


