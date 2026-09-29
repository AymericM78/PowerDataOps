# Command : `New-XrmCascadeConfiguration` 

## Description

**Create a CascadeConfiguration object for a one-to-many relationship.** : Build the cascading behavior of a 1:N relationship (what happens to the child rows when the parent row is assigned, deleted, shared...).
Only the given actions are set: with Set-XrmRelationship, the other actions keep their current value; with a new relationship, the platform applies its defaults.
Values: Cascade (all), Active (active rows only), UserOwned (rows owned by the same user), NoCascade, RemoveLink (delete only), Restrict (delete only).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Assign|CascadeType|1|false||Behavior when the parent row is assigned.
Delete|CascadeType|2|false||Behavior when the parent row is deleted: Cascade, RemoveLink or Restrict.
Merge|CascadeType|3|false||Behavior when the parent row is merged: Cascade or NoCascade.
Reparent|CascadeType|4|false||Behavior when the parent row changes owner through its own parent.
Share|CascadeType|5|false||Behavior when the parent row is shared.
Unshare|CascadeType|6|false||Behavior when the parent row is unshared.
RollupView|CascadeType|7|false||Behavior of the rollup views: Cascade, Active, UserOwned or NoCascade.
Archive|CascadeType|8|false||Behavior when the parent row is archived (long term retention): Cascade, RemoveLink, Restrict or NoCascade.

## Outputs
Microsoft.Xrm.Sdk.Metadata.CascadeConfiguration.

## Usage

```Powershell 
New-XrmCascadeConfiguration [[-Assign] {NoCascade | Cascade | Active | UserOwned | RemoveLink | Restrict}] [[-Delete] {NoCascade | Cascade | Active | UserOwned | RemoveLink | Restrict}] [[-Merge] {NoCascade | Cascade | Active | UserOwned | RemoveLink | Restrict}] [[-Reparent] {NoCascade | Cascade | Active | UserOwned | RemoveLink | Restrict}] [[-Share] {NoCascade | Cascade | Active | UserOwned | RemoveLink | Restrict}] [[-Unshare] {NoCascade | Cascade | Active | UserOwned | RemoveLink | Restrict}] [[-RollupView] {NoCascade | Cascade | Active | UserOwned | RemoveLink | Restrict}] [[-Archive] {NoCascade | Cascade | Active | UserOwned | RemoveLink | Restrict}] [<CommonParameters>]
``` 

## Examples

```Powershell 
# Parental behavior
$cascade = New-XrmCascadeConfiguration -Assign Cascade -Delete Cascade -Merge Cascade -Reparent Cascade -Share Cascade -Unshare Cascade -RollupView NoCascade;
``` 


```Powershell 
# Block the deletion of a parent that still has children
Set-XrmRelationship -XrmClient $xrmClient -Name "new_project_task" -CascadeConfiguration (New-XrmCascadeConfiguration -Delete Restrict);
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmCascadeConfiguration.md


