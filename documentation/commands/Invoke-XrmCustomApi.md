# Command : `Invoke-XrmCustomApi` 

## Description

**Call a custom API (or any SDK message) by name.** : Build the request from a hashtable of parameters, execute it and return the response.
Values are passed as they are typed: EntityReference, Guid, int, OptionSetValue, arrays... (see Add-XrmRequestParameter). A bound custom API takes its record in the Target parameter.
With JsonOutput, the named output parameter is read as JSON and the deserialized object is returned instead of the response ($null when the output is empty).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Custom API unique name (message name).
Parameters|Hashtable|3|false||Request parameters, by name. (Default: none)
JsonOutput|String|4|false||Name of an output parameter holding JSON to deserialize and return.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse, or PSCustomObject with JsonOutput.

## Usage

```Powershell 
Invoke-XrmCustomApi [[-XrmClient] <ServiceClient>] [-Name] <String> [[-Parameters] <Hashtable>] [[-JsonOutput] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$response = Invoke-XrmCustomApi -XrmClient $xrmClient -Name "contoso_RecalculateScore" -Parameters @{ Target = $account.Reference; Force = $true };
$response.Results["Score"];
``` 


```Powershell 
$result = Invoke-XrmCustomApi -XrmClient $xrmClient -Name "contoso_GetSettings" -JsonOutput "SettingsJson";
$result.maxBatchSize;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmCustomApi.md


