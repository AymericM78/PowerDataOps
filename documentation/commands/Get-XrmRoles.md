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


## Usage

```Powershell 
Get-XrmRoles [[-XrmClient] <ServiceClient>] [[-BusinessUnitId] <Guid>] [-OnlyRoots] [[-Columns] <String[]>] [-ExportPrivileges] [<CommonParameters>]
``` 


