# Command : `Remove-XrmUserFromTeam` 

## Description

**Remove user from a team.** : Disassociate a system user from a specified team using the teammembership_association relationship.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
TeamReference|EntityReference|2|true||Team entity reference.
UserReferences|EntityReference[]|3|true||Array of system user entity references to remove from the team.


## Usage

```Powershell 
Remove-XrmUserFromTeam [[-XrmClient] <ServiceClient>] [-TeamReference] <EntityReference> [-UserReferences] <EntityReference[]> [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$teamRef = New-XrmEntityReference -LogicalName "team" -Id $teamId;
$userRef1 = New-XrmEntityReference -LogicalName "systemuser" -Id $userId1;
$userRef2 = New-XrmEntityReference -LogicalName "systemuser" -Id $userId2;
Remove-XrmUserFromTeam -XrmClient $xrmClient -TeamReference $teamRef -UserReferences @($userRef1, $userRef2);
``` 


