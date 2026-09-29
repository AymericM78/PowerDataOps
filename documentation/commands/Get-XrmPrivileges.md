# Command : `Get-XrmPrivileges` 

## Description

**Retrieve privileges with their table, access right and supported depths.** : Read privilege definitions (privilege table) and describe each one: Id, Name, AccessRight (Read, Write, Create, Delete, Append, AppendTo, Assign, Share, or None for the miscellaneous privileges such as prvBypassCustomPlugins), AccessRightValue, EntityLogicalName, EntityLogicalNames, CanBeBasic, CanBeLocal, CanBeDeep, CanBeGlobal, SupportedDepths.
A privilege can cover several tables (prvReadActivity covers every activity table, prvReadAccount also covers customeraddress): EntityLogicalNames lists them all.
EntityLogicalName is the table named after the privilege (prvReadAccount => account), the filtered table with -EntityLogicalName, the only table, or $null when none of these applies.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String[]|2|false||Privilege names (e.g. "prvReadAccount"). (Default: all)
Id|Guid[]|3|false||Privilege unique identifiers. (Default: all)
EntityLogicalName|String|4|false||Keep the privileges that apply to this table. (Default: all)
AccessRight|String|5|false||Keep the privileges of this access right: Read, Write, Create, Delete, Append, AppendTo, Assign, Share. (Default: all)
RoleId|Guid|6|false||Keep the privileges granted to this security role. (Default: all)

## Outputs
PSCustomObject[]. One object per privilege.

## Usage

```Powershell 
Get-XrmPrivileges [[-XrmClient] <ServiceClient>] [[-Name] <String[]>] [[-Id] <Guid[]>] [[-EntityLogicalName] <String>] [[-AccessRight] <String>] [[-RoleId] <Guid>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$privilege = Get-XrmPrivileges -XrmClient $xrmClient -EntityLogicalName "account" -AccessRight Write;   # prvWriteAccount
``` 


```Powershell 
Get-XrmPrivileges -XrmClient $xrmClient -Name "prvBypassCustomPlugins" | Select-Object Name, SupportedDepths;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPrivileges.md


