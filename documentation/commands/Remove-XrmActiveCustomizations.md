# Command : `Remove-XrmActiveCustomizations` 

## Description

**Remove active customizations.** : Performs a cleaning on Active Layer to remove unmanaged customizations for given component.
Returns the RemoveActiveCustomizations response. A failure raises an error, except a "not found" error when IgnoreMissing is set (a warning is written and $null is returned).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionComponentName|String|2|true||Solution component type name, as returned by Get-XrmSolutionComponentName (e.g. "SavedQuery", "SystemForm", "WebResource").
ComponentId|Guid|3|true||Solution component unique identifier to clean.
IgnoreMissing|SwitchParameter|named|false|False|Do not raise an error when the component or its active layer cannot be found.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The RemoveActiveCustomizations response ($null when ignored).

## Usage

```Powershell 
Remove-XrmActiveCustomizations [[-XrmClient] <ServiceClient>] [-SolutionComponentName] <String> [-ComponentId] <Guid> [-IgnoreMissing] [<CommonParameters>]
``` 

## Examples

```Powershell 
$response = Remove-XrmActiveCustomizations -XrmClient $xrmClient -SolutionComponentName "SavedQuery" -ComponentId $viewId;
``` 


```Powershell 
Remove-XrmActiveCustomizations -XrmClient $xrmClient -SolutionComponentName "SystemForm" -ComponentId $formId -IgnoreMissing | Out-Null;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmActiveCustomizations.md


