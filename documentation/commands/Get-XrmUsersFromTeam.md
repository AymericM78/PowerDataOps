# Command : `Get-XrmUsersFromTeam` 

## Description

**Retrieve users from a team.** : Get all system users that are members of a specified team.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
TeamReference|EntityReference|2|true||Team entity reference.
Columns|String[]|3|false|@("fullname", "internalemailaddress")|Specify expected columns to retrieve. (Default : fullname, internalemailaddress)

## Outputs
System.Management.Automation.PSObject[]

## Usage

```Powershell 
Get-XrmUsersFromTeam [[-XrmClient] <ServiceClient>] [-TeamReference] <EntityReference> [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$teamRef = New-XrmEntityReference -LogicalName "team" -Id $teamId;
$users = Get-XrmUsersFromTeam -XrmClient $xrmClient -TeamReference $teamRef;
``` 


