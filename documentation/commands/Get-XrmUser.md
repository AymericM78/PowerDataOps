# Command : `Get-XrmUser` 

## Description

**Retrieve user.** : Get system user according to given ID, or primary email, with expected columns. Without UserId nor Email, the current user is returned.
With Email, when several users share the address, the only enabled one is returned; an error is raised when that still leaves several users. Returns $null when no user has this address.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
UserId|Guid|2|false||System user unique identifier.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)
Email|String|4|false||Primary email of the user (internalemailaddress, case-insensitive). Cannot be combined with UserId.

## Outputs
PSCustomObject. System user row (XrmObject).

## Usage

```Powershell 
Get-XrmUser [[-XrmClient] <ServiceClient>] [[-UserId] <Guid>] [[-Columns] <String[]>] [[-Email] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$me = Get-XrmUser -XrmClient $xrmClient -Columns "fullname";
``` 


```Powershell 
$user = Get-XrmUser -XrmClient $xrmClient -Email "jane.doe@contoso.com" -Columns "fullname", "businessunitid";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUser.md


