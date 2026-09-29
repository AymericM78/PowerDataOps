# Command : `Test-XrmUserPrivilege` 

## Description

**Check whether a user holds a privilege.** : Ask the platform whether the user holds the privilege through their security roles (RetrieveUserPrivilegeByPrivilegeName), optionally at a minimum depth.
Raises an error when the privilege does not exist.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
PrivilegeName|String|2|true||Privilege name (e.g. "prvBypassCustomPlugins", "prvReadAccount").
UserId|Guid|3|false||System user unique identifier. (Default: current user)
Depth|PrivilegeDepth|4|false||Minimum depth (Basic < Local < Deep < Global). (Default: any depth)

## Outputs
System.Boolean. True when the user holds the privilege (at the minimum depth, if given).

## Usage

```Powershell 
Test-XrmUserPrivilege [[-XrmClient] <ServiceClient>] [-PrivilegeName] <String> [[-UserId] <Guid>] [[-Depth] {Basic | Local | Deep | Global | RecordFilter}] [<CommonParameters>]
``` 

## Examples

```Powershell 
if (-not (Test-XrmUserPrivilege -XrmClient $xrmClient -PrivilegeName "prvBypassCustomPlugins")) {
    throw "The migration account cannot bypass plug-ins.";
}
``` 


```Powershell 
$canReadAll = Test-XrmUserPrivilege -XrmClient $xrmClient -PrivilegeName "prvReadAccount" -UserId $user.Id -Depth Global;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmUserPrivilege.md


