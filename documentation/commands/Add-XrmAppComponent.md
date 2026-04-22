# Command : `Add-XrmAppComponent` 

## Description

**Add components to a model-driven app.** : Add one or more components (tables, forms, views, dashboards, BPF, sitemap, etc.) to an existing model-driven app using the AddAppComponents SDK action.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleId|Guid|2|true||Guid of the appmodule to add components to.
ComponentId|Guid|3|true||Guid of the component to add.
ComponentEntityLogicalName|String|4|true||Entity type name of the component (e.g. savedquery, systemform, sitemap, workflow, entity).
ComponentIdAttributeName|String|5|false||Primary key attribute name of the component entity (e.g. savedqueryid, formid, sitemapid). Optional â€” auto-resolved from ComponentEntityLogicalName when possible.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The AddAppComponents response.

## Usage

```Powershell 
Add-XrmAppComponent [[-XrmClient] <ServiceClient>] [-AppModuleId] <Guid> [-ComponentId] <Guid> [-ComponentEntityLogicalName] <String> 
[[-ComponentIdAttributeName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Add-XrmAppComponent -AppModuleId $appId -ComponentId $viewId -ComponentEntityLogicalName "savedquery";
Add-XrmAppComponent -AppModuleId $appId -ComponentId $formId -ComponentEntityLogicalName "systemform";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/addappcomponents


