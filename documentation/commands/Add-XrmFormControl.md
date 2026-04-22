# Command : `Add-XrmFormControl` 

## Description

**Add a PCF custom control to a form field.** : Add a Power Apps Component Framework (PCF) custom control binding onto a field in a model-driven app form
by modifying the FormXML of the systemform record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
FormReference|EntityReference|2|true||EntityReference of the systemform record to modify.
FieldName|String|3|true||Logical name of the field on the form to bind the control to.
ControlName|String|4|true||Full unique name of the PCF control (e.g. "MscrmControls.FieldControls.LinearSliderControl").
Parameters|Hashtable|5|false||Hashtable of control parameters with their static values. Optional.
Example: @{ "min" = "0"; "max" = "1000"; "step" = "1" }
Publish|Boolean|6|false|True|Publish customizations after update. Default: true.

## Outputs
System.Void.

## Usage

```Powershell 
Add-XrmFormControl [[-XrmClient] <ServiceClient>] [-FormReference] <EntityReference> [-FieldName] <String> [-ControlName] <String> [[-Parameters] 
<Hashtable>] [[-Publish] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$formRef = New-XrmEntityReference -LogicalName "systemform" -Id $formId;
Add-XrmFormControl -FormReference $formRef -FieldName "revenue" -ControlName "MscrmControls.FieldControls.LinearSliderControl" -Parameters @{ "min" = "0"; "max" = "1000000"; "step" = "100" };
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/component-framework/add-custom-controls-to-a-field-or-entity


