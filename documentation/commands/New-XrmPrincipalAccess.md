# Command : `New-XrmPrincipalAccess` 

## Description

**Create a PrincipalAccess object.** : Instantiate a Microsoft.Crm.Sdk.Messages.PrincipalAccess object with the specified principal and access rights.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Principal|EntityReference|1|true||User or team entity reference.
AccessRights|AccessRights|2|false|ReadAccess, WriteAccess, AppendAccess, AppendToAccess|Access rights to grant. Default: ReadAccess + WriteAccess + AppendAccess + AppendToAccess.

## Outputs
Microsoft.Crm.Sdk.Messages.PrincipalAccess.

## Usage

```Powershell 
New-XrmPrincipalAccess [-Principal] <EntityReference> [[-AccessRights] {None | ReadAccess | WriteAccess | AppendAccess | AppendToAccess | CreateAccess | DeleteAccess | ShareAccess | AssignAccess}] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$principalAccess = New-XrmPrincipalAccess -Principal $userRef -AccessRights ([Microsoft.Crm.Sdk.Messages.AccessRights]::ReadAccess);
``` 


