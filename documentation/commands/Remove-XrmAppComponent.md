# Command : `Remove-XrmAppComponent` 

## Description

**Remove components from a model-driven app.** : Remove one or more components from an existing model-driven app using the RemoveAppComponents SDK action.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleId|Guid|2|true||Guid of the appmodule to remove components from.
ComponentId|Guid|3|true||Guid of the component to remove.
ComponentEntityLogicalName|String|4|true||Entity type name of the component (e.g. savedquery, systemform, sitemap, workflow, entity).
ComponentIdAttributeName|String|5|false||Primary key attribute name of the component entity. Optional â€” auto-resolved from ComponentEntityLogicalName when possible.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The RemoveAppComponents response.

## Usage

```Powershell 
Remove-XrmAppComponent [[-XrmClient] <ServiceClient>] [-AppModuleId] <Guid> [-ComponentId] <Guid> [-ComponentEntityLogicalName] <String> 
[[-ComponentIdAttributeName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmAppComponent -AppModuleId $appId -ComponentId $viewId -ComponentEntityLogicalName "savedquery";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/removeappcomponents


