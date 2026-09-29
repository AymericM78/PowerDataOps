# Command : `Get-XrmFlowTriggers` 

## Description

**Retrieve the Dataverse triggers registered by cloud flows.** : Read the callback registrations (callbackregistration) that the "When a row is added, modified or deleted" trigger creates when a flow is turned on.
Each row gives the table (entityname), the change type (message: added, deleted, modified, or a combination), the scope, the filtering columns and the filter expression.
The callback URL is not read by default: it grants access to the flow.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|false||Table logical name. (Default: all)
Columns|String[]|3|false|@("name", "entityname", "message", "sdkmessagename", "scope", "filteringattributes", "filterexpression", "runas", "softdeletestatus", "createdon")|Columns to return. (Default: name, entityname, message, sdkmessagename, scope, filteringattributes, filterexpression, runas, softdeletestatus, createdon)

## Outputs
PSCustomObject[]. Callback registration rows (XrmObject).

## Usage

```Powershell 
Get-XrmFlowTriggers [[-XrmClient] <ServiceClient>] [[-EntityLogicalName] <String>] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$triggers = Get-XrmFlowTriggers -XrmClient $xrmClient -EntityLogicalName "account";
$triggers | Select-Object name, message, filteringattributes;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmFlowTriggers.md


