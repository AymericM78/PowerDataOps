# Command : `Test-XrmComponentCustomization` 

## Description

**Test active-layer customization for a solution component.** : Checks whether a component has meaningful customizations in the Active layer
by querying msdyn_componentlayer and parsing msdyn_changes.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ComponentId|Guid|2|true||Solution component unique identifier.
SolutionComponentName|String|3|true||Solution component name (for example: Entity, Attribute, SavedQuery, SystemForm).
ExcludedProperties|String[]|4|false|@("displaymask", "createdon", "modifiedon", "attributetypeid", "attributelogicaltypeid")|Changed properties to ignore when evaluating meaningful customizations.
IncludedProperties|String[]|5|false|@()|If provided, only these changed properties are evaluated.
ReturnDetails|SwitchParameter|named|false|False|Return a detailed object instead of a boolean.

## Outputs
System.Boolean or PSCustomObject.

## Usage

```Powershell 
Test-XrmComponentCustomization [[-XrmClient] <ServiceClient>] [-ComponentId] <Guid> [-SolutionComponentName] <String> [[-ExcludedProperties] <String[]>] 
[[-IncludedProperties] <String[]>] [-ReturnDetails] [<CommonParameters>]
``` 

## Examples

```Powershell 
$isCustomized = Test-XrmComponentCustomization -ComponentId $componentId -SolutionComponentName "Attribute";
``` 


```Powershell 
$details = Test-XrmComponentCustomization -ComponentId $componentId -SolutionComponentName "SystemForm" -ReturnDetails;
``` 


