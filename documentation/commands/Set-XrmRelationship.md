# Command : `Set-XrmRelationship` 

## Description

**Update the cascading behavior or the navigation menu of a relationship.** : Read the relationship, apply the given settings and send it back (UpdateRelationship).
CascadeConfiguration and AssociatedMenuConfiguration apply to one-to-many relationships; Entity1AssociatedMenuConfiguration and Entity2AssociatedMenuConfiguration to many-to-many ones.
Only the properties set on the given configurations change (see New-XrmCascadeConfiguration, New-XrmAssociatedMenuConfiguration): the others keep their current value.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Relationship schema name.
CascadeConfiguration|CascadeConfiguration|3|false||Cascading behavior (1:N).
AssociatedMenuConfiguration|AssociatedMenuConfiguration|4|false||Navigation menu of the related rows on the parent form (1:N).
Entity1AssociatedMenuConfiguration|AssociatedMenuConfiguration|5|false||Navigation menu on the first table of a N:N relationship.
Entity2AssociatedMenuConfiguration|AssociatedMenuConfiguration|6|false||Navigation menu on the second table of a N:N relationship.
MergeLabels|Boolean|7|false|True|Keep the labels of the languages that are not given. (Default: true)
SolutionUniqueName|String|8|false||Unmanaged solution to add the relationship to.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. UpdateRelationship response.

## Usage

```Powershell 
Set-XrmRelationship [[-XrmClient] <ServiceClient>] [-Name] <String> [[-CascadeConfiguration] <CascadeConfiguration>] [[-AssociatedMenuConfiguration] <AssociatedMenuConfiguration>] [[-Entity1AssociatedMenuConfiguration] <AssociatedMenuConfiguration>] [[-Entity2AssociatedMenuConfiguration] <AssociatedMenuConfiguration>] [[-MergeLabels] <Boolean>] [[-SolutionUniqueName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmRelationship -XrmClient $xrmClient -Name "new_project_task" -CascadeConfiguration (New-XrmCascadeConfiguration -Delete Restrict -Assign NoCascade);
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmRelationship.md


