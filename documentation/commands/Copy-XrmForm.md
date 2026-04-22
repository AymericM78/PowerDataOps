# Command : `Copy-XrmForm` 

## Description

**Copy an existing form in Microsoft Dataverse.** : Clone a systemform record using the CopySystemForm SDK action. Creates an exact copy of the source form with a new name.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SourceFormId|Guid|2|true||Guid of the systemform record to copy.
NewName|String|3|false||Display name for the copied form. Optional. If not provided, Dataverse generates a default name.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the newly created systemform record.

## Usage

```Powershell 
Copy-XrmForm [[-XrmClient] <ServiceClient>] [-SourceFormId] <Guid> [[-NewName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$newFormRef = Copy-XrmForm -SourceFormId $existingFormId -NewName "Account Main Form - Copy";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/copysystemform


