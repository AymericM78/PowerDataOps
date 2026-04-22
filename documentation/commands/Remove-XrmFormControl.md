# Command : `Remove-XrmFormControl` 

## Description

**Remove a PCF custom control from a form field.** : Remove a Power Apps Component Framework (PCF) custom control binding from a field in a model-driven app form
by modifying the FormXML of the systemform record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
FormReference|EntityReference|2|true||EntityReference of the systemform record to modify.
FieldName|String|3|true||Logical name of the field to remove the control from.
ControlName|String|4|false||Full unique name of the PCF control to remove. Optional. If not specified, removes all custom controls from the field.
Publish|Boolean|5|false|True|Publish customizations after update. Default: true.

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmFormControl [[-XrmClient] <ServiceClient>] [-FormReference] <EntityReference> [-FieldName] <String> [[-ControlName] <String>] [[-Publish] 
<Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$formRef = New-XrmEntityReference -LogicalName "systemform" -Id $formId;
Remove-XrmFormControl -FormReference $formRef -FieldName "revenue" -ControlName "MscrmControls.FieldControls.LinearSliderControl";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/component-framework/add-custom-controls-to-a-field-or-entity


