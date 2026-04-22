# Command : `Revoke-XrmRecordAccess` 

## Description

**Revoke access on a record for a user or team.** : Remove all granted access rights on a Dataverse record for a specified principal (user or team).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
PrincipalReference|EntityReference|2|true||User or team entity reference to revoke access from.
TargetReference|EntityReference|3|true||Target record entity reference to unshare.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The RevokeAccess response.

## Usage

```Powershell 
Revoke-XrmRecordAccess [[-XrmClient] <ServiceClient>] [-PrincipalReference] <EntityReference> [-TargetReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$userRef = New-XrmEntityReference -LogicalName "systemuser" -Id $userId;
$accountRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
Revoke-XrmRecordAccess -XrmClient $xrmClient -PrincipalReference $userRef -TargetReference $accountRef;
``` 


