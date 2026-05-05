# Command : `Publish-XrmComponent` 

## Description

**Publish a specific Dataverse component using a targeted PublishXml request.** : Publish one component (app module, entity, option set, web resource, ribbon, etc.)
without triggering a full Publish-XrmCustomizations. Builds the required
<importexportxml> payload from the component name and identifier.

Use this instead of Publish-XrmCustomizations when you want to target a single
component and avoid the overhead of a full publish cycle.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ComponentName|String|2|true||XML element name of the component type to publish.
Common values: appmodule, entity, optionset, webresource, ribbon, sitemap, workflow.
ComponentId|String|3|true||Identifier of the component: GUID string for record-based components (appmodule,
webresource), logical name for schema-based components (entity, optionset, ribbon).

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. Response from the PublishXml request.

## Usage

```Powershell 
Publish-XrmComponent [[-XrmClient] <ServiceClient>] [-ComponentName] <String> [-ComponentId] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
# Publish a model-driven app
Publish-XrmComponent -ComponentName "appmodule" -ComponentId "3d9e2f1a-...";
``` 


```Powershell 
# Publish a single entity's customizations
Publish-XrmComponent -ComponentName "entity" -ComponentId "account";
``` 


```Powershell 
# Publish a global option set
Publish-XrmComponent -ComponentName "optionset" -ComponentId "my_status";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/publishxml?view=dataverse-latest


