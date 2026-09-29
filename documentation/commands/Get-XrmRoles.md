# Command : `Get-XrmRoles` 

## Description

**Retrieve security roles.** : Get security roles according to different criterias.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
BusinessUnitId|Guid|2|false||Business Unit unique identifier where roles are associated.
OnlyRoots|SwitchParameter|named|false|False|Specify if parent roles are retrieved or not. (Default : false = All roles)
Columns|String[]|3|false|@("roleid", "name", "parentrootroleid", "businessunitid")|Specify expected columns to retrieve. (Default : all columns)
ExportPrivileges|SwitchParameter|named|false|False|Specify if privileges are retrieved or not. (Default : false = No privileges)
Name|String|4|false||Role name. Wildcards * are accepted (e.g. "Contoso*"). A role exists once per business unit: combine with OnlyRoots or BusinessUnitId to get one row. (Default: all)

## Outputs
PSCustomObject[]. Role rows (XrmObject), with a Privileges property when ExportPrivileges is set.

## Usage

```Powershell 
Get-XrmRoles [[-XrmClient] <ServiceClient>] [[-BusinessUnitId] <Guid>] [-OnlyRoots] [[-Columns] <String[]>] [-ExportPrivileges] [[-Name] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$role = Get-XrmRoles -XrmClient $xrmClient -Name "Salesperson" -OnlyRoots;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRoles.md


