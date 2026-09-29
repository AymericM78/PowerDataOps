# Command : `New-XrmAssociatedMenuConfiguration` 

## Description

**Create an AssociatedMenuConfiguration object for a relationship.** : Build how the related rows appear in the navigation of the parent form (classic "Related" menu): behavior, group, label and order.
Only the given properties are set: with Set-XrmRelationship, the others keep their current value.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Behavior|AssociatedMenuBehavior|1|false||UseCollectionName (plural name of the related table), UseLabel (Label below) or DoNotDisplay.
Group|AssociatedMenuGroup|2|false||Details, Sales, Service or Marketing.
Label|String|3|false||Menu label, with Behavior UseLabel (single language, see LanguageCode).
Labels|Hashtable|4|false||Menu label by language code (e.g. @{ 1033 = "Tasks"; 1036 = "Taches" }), instead of Label.
LanguageCode|Int32|5|false|1033|Language of Label. (Default: 1033)
Order|Int32|6|false|0|Position in the group.

## Outputs
Microsoft.Xrm.Sdk.Metadata.AssociatedMenuConfiguration.

## Usage

```Powershell 
New-XrmAssociatedMenuConfiguration [[-Behavior] {UseCollectionName | UseLabel | DoNotDisplay}] [[-Group] {Details | Sales | Service | Marketing}] [[-Label] <String>] [[-Labels] <Hashtable>] [[-LanguageCode] <Int32>] [[-Order] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$menu = New-XrmAssociatedMenuConfiguration -Behavior UseLabel -Group Details -Labels @{ 1033 = "Project tasks"; 1036 = "Taches du projet" } -Order 10000;
Set-XrmRelationship -XrmClient $xrmClient -Name "new_project_task" -AssociatedMenuConfiguration $menu;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmAssociatedMenuConfiguration.md


