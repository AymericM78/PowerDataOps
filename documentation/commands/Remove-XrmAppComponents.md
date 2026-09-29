# Command : `Remove-XrmAppComponents` 

## Description

**Remove multiple components from a model-driven app in a single SDK call.** : Remove a batch of components from an existing model-driven app using a single RemoveAppComponents request.
More efficient than calling Remove-XrmAppComponent in a loop because all references are sent in one request.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleId|Guid|2|true||Guid of the appmodule to remove components from.
Components|Object[]|3|true||Collection of components to remove. Supported input shapes:
- [Microsoft.Xrm.Sdk.EntityReference]
- @{ ComponentId = <Guid>; ComponentEntityLogicalName = <string> }
- PSCustomObject with ComponentId / ComponentEntityLogicalName (or Id / LogicalName) properties
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The RemoveAppComponents response.

## Usage

```Powershell 
Remove-XrmAppComponents [[-XrmClient] <ServiceClient>] [-AppModuleId] <Guid> [-Components] <Object[]> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$refs = @(
    (New-XrmEntityReference -LogicalName "savedquery" -Id $viewId),
    (New-XrmEntityReference -LogicalName "systemform" -Id $formId)
);
Remove-XrmAppComponents -AppModuleId $appId -Components $refs;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/removeappcomponents


