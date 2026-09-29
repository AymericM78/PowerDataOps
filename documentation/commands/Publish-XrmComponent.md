# Command : `Publish-XrmComponent` 

## Description

**Publish a specific Dataverse component using a targeted PublishXml request.** : Publish one or several components of the same type (app module, entity, option set, web resource, ribbon, etc.)
without triggering a full Publish-XrmCustomizations. Builds the required
<importexportxml> payload from the component name and identifiers: one request for all of them.

Use this instead of Publish-XrmCustomizations when you want to target a few
components and avoid the overhead of a full publish cycle.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ComponentName|String|2|true||XML element name of the component type to publish.
Common values: appmodule, entity, optionset, webresource, ribbon, sitemap, workflow.
ComponentId|String[]|3|true||Identifiers of the components: GUID strings for record-based components (appmodule,
webresource), logical names for schema-based components (entity, optionset, ribbon).
TimeoutInMinutes|Int32|4|false|0|Maximum wait for the publish, which is synchronous. The request is sent through a clone of the connection created with this timeout (a ServiceClient keeps the timeout it was created with). (Default: the timeout of the connection)
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. Response from the PublishXml request.

## Usage

```Powershell 
Publish-XrmComponent [[-XrmClient] <ServiceClient>] [-ComponentName] <String> [-ComponentId] <String[]> [[-TimeoutInMinutes] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
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
# Publish several apps in one request, allowing 20 minutes
Publish-XrmComponent -XrmClient $xrmClient -ComponentName "appmodule" -ComponentId $salesApp.Id, $serviceApp.Id -TimeoutInMinutes 20;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Publish-XrmComponent.md


