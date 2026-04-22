# Command : `Share-XrmRecord` 

## Description

**Share a record with a user or team.** : Grant access rights on a Dataverse record to a specified principal (user or team).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
TargetReference|EntityReference|2|true||Target record entity reference to share.
PrincipalAccess|PrincipalAccess|3|true||PrincipalAccess object created via New-XrmPrincipalAccess.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The GrantAccess response.

## Usage

```Powershell 
Share-XrmRecord [[-XrmClient] <ServiceClient>] [-TargetReference] <EntityReference> [-PrincipalAccess] <PrincipalAccess> [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$userRef = New-XrmEntityReference -LogicalName "systemuser" -Id $userId;
$accountRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
$principalAccess = New-XrmPrincipalAccess -Principal $userRef;
Share-XrmRecord -XrmClient $xrmClient -TargetReference $accountRef -PrincipalAccess $principalAccess;
``` 


