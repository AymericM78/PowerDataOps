# Command : `Get-XrmAppComponents` 

## Description

**Retrieve components of a model-driven app.** : Get all components included in a published model-driven app using the RetrieveAppComponents SDK function.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleId|Guid|2|true||Guid of the appmodule to retrieve components from.

## Outputs
Microsoft.Xrm.Sdk.EntityCollection. Collection of app component records.

## Usage

```Powershell 
Get-XrmAppComponents [[-XrmClient] <ServiceClient>] [-AppModuleId] <Guid> [<CommonParameters>]
``` 

## Examples

```Powershell 
$components = Get-XrmAppComponents -AppModuleId $appId;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/retrieveappcomponents


