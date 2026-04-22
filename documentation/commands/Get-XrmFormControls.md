# Command : `Get-XrmFormControls` 

## Description

**List PCF custom controls configured on a form.** : Parse the FormXML of a systemform record and return all custom control bindings (PCF controls).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
FormReference|EntityReference|2|true||EntityReference of the systemform record to inspect.

## Outputs
PSCustomObject[]. Array of objects with FieldName, ControlId, ControlName, and FormFactor properties.

## Usage

```Powershell 
Get-XrmFormControls [[-XrmClient] <ServiceClient>] [-FormReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
$formRef = New-XrmEntityReference -LogicalName "systemform" -Id $formId;
$controls = Get-XrmFormControls -FormReference $formRef;
$controls | Format-Table;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/component-framework/add-custom-controls-to-a-field-or-entity


