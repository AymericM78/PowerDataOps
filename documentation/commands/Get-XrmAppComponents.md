# Command : `Get-XrmAppComponents` 

## Description

**Retrieve components of a model-driven app.** : Get all components included in a published model-driven app using the RetrieveAppComponents SDK function.
RetrieveAppComponents fails on an app that was never published ("appmodule ... Does Not Exist"). With Unpublished, the components are read from the appmodulecomponent table instead, which holds them as soon as they are added.
Web resources are never app components: the platform refuses to add them to an app.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleId|Guid|2|true||Guid of the appmodule to retrieve components from.
Unpublished|SwitchParameter|named|false|False|Read the components of the app in its current (unpublished) state from the appmodulecomponent table.

## Outputs
Microsoft.Xrm.Sdk.EntityCollection. Collection of app component records (componenttype, objectid).

## Usage

```Powershell 
Get-XrmAppComponents [[-XrmClient] <ServiceClient>] [-AppModuleId] <Guid> [-Unpublished] [<CommonParameters>]
``` 

## Examples

```Powershell 
$components = Get-XrmAppComponents -AppModuleId $appId;
``` 


```Powershell 
# App being built, not published yet
$components = Get-XrmAppComponents -XrmClient $xrmClient -AppModuleId $appId -Unpublished;
$siteMaps = $components.Entities | Where-Object { $_["componenttype"].Value -eq 62 };
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/retrieveappcomponents


