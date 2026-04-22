# Command : `Add-XrmAppModule` 

## Description

**Create a new model-driven app in Microsoft Dataverse.** : Create a new appmodule record (model-driven app) with the specified name and properties.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Display name for the app.
UniqueName|String|3|true||Unique name for the app (auto-prefixed with publisher prefix).
Description|String|4|false||App description. Optional.
WebResourceId|Guid|5|false||Id of the web resource to use as app icon. Optional. Defaults to system default icon.
SolutionUniqueName|String|6|false||Solution unique name to add the app to. Optional.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created appmodule record.

## Usage

```Powershell 
Add-XrmAppModule [[-XrmClient] <ServiceClient>] [-Name] <String> [-UniqueName] <String> [[-Description] <String>] [[-WebResourceId] <Guid>] 
[[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$appRef = Add-XrmAppModule -Name "My Custom App" -UniqueName "myapp";
$appRef = Add-XrmAppModule -Name "My App" -UniqueName "myapp" -SolutionUniqueName "MySolution";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code


