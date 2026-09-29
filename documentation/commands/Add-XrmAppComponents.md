# Command : `Add-XrmAppComponents` 

## Description

**Add multiple components to a model-driven app in a single SDK call.** : Add a batch of components (tables, forms, views, dashboards, BPF, sitemap, etc.) to an existing model-driven app using a single AddAppComponents request.
More efficient than calling Add-XrmAppComponent in a loop because all references are sent in one request.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleId|Guid|2|true||Guid of the appmodule to add components to.
Components|Object[]|3|true||Collection of components to add. Supported input shapes:
- [Microsoft.Xrm.Sdk.EntityReference]
- @{ ComponentId = <Guid>; ComponentEntityLogicalName = <string> }
- PSCustomObject with ComponentId / ComponentEntityLogicalName (or Id / LogicalName) properties
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The AddAppComponents response.

## Usage

```Powershell 
Add-XrmAppComponents [[-XrmClient] <ServiceClient>] [-AppModuleId] <Guid> [-Components] <Object[]> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$refs = @(
    (New-XrmEntityReference -LogicalName "savedquery" -Id $viewId),
    (New-XrmEntityReference -LogicalName "systemform" -Id $formId)
);
Add-XrmAppComponents -AppModuleId $appId -Components $refs;
``` 


```Powershell 
$components = @(
    [pscustomobject]@{ ComponentId = $viewId; ComponentEntityLogicalName = "savedquery" },
    [pscustomobject]@{ ComponentId = $formId; ComponentEntityLogicalName = "systemform" }
);
Add-XrmAppComponents -AppModuleId $appId -Components $components;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/addappcomponents


