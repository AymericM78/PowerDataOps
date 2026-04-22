# Command : `Test-XrmView` 

## Description

**Validate a saved query (view) in Microsoft Dataverse.** : Check if a saved query (view) definition is valid using the ValidateSavedQuery SDK action.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ViewId|Guid|2|true||Guid of the savedquery record to validate.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The ValidateSavedQuery response.

## Usage

```Powershell 
Test-XrmView [[-XrmClient] <ServiceClient>] [-ViewId] <Guid> [<CommonParameters>]
``` 

## Examples

```Powershell 
$result = Test-XrmView -ViewId $viewId;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/validatesavedquery


