# Command : `Test-XrmAppModule` 

## Description

**Validate a model-driven app.** : Check a model-driven app for missing dependencies using the ValidateApp SDK function.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleId|Guid|2|true||Guid of the appmodule to validate.

## Outputs
PSCustomObject. Validation result with ValidationSuccess (bool) and ValidationIssueList (array).

## Usage

```Powershell 
Test-XrmAppModule [[-XrmClient] <ServiceClient>] [-AppModuleId] <Guid> [<CommonParameters>]
``` 

## Examples

```Powershell 
$result = Test-XrmAppModule -AppModuleId $appId;
if (-not $result.ValidationSuccess) { $result.ValidationIssueList | Format-Table; }
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/validateapp


