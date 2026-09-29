# Command : `Get-XrmWorkflows` 

## Description

**Retrieve workflows.** : Get workflows (processes: classic workflows, business rules, actions, business process flows, cloud flows...) with expected columns, optionally filtered.
Processes of the Basic solution are excluded, as before.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Columns|String[]|2|false|@( "name", "category", "primaryentity", "uniquename", "statecode", "statuscode")|Specify expected columns to retrieve. (Default : "name", "category", "primaryentity", "uniquename", "statecode", "statuscode")
Category|Int32[]|3|false||Process categories to keep: 0 Workflow, 1 Dialog, 2 Business rule, 3 Action, 4 Business process flow, 5 Cloud flow (modern flow), 6 Desktop flow, 7 AI flow. (Default: all)
Type|Int32[]|4|false||Process types to keep: 1 Definition, 2 Activation, 3 Template. (Default: all)
PrimaryEntity|String|5|false||Logical name of the table the process runs on. (Default: all)
State|Int32[]|6|false||States to keep: 0 Draft, 1 Activated, 2 Suspended. (Default: all)
Name|String|7|false||Process name. Wildcards * are accepted (e.g. "Contoso*"). (Default: all)

## Outputs
PSCustomObject[]. Workflow rows (XrmObject).

## Usage

```Powershell 
Get-XrmWorkflows [[-XrmClient] <ServiceClient>] [[-Columns] <String[]>] [[-Category] <Int32[]>] [[-Type] <Int32[]>] [[-PrimaryEntity] <String>] [[-State] <Int32[]>] [[-Name] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$workflows = Get-XrmWorkflows -XrmClient $xrmClient;
``` 


```Powershell 
# Activated cloud flows on account
$flows = Get-XrmWorkflows -XrmClient $xrmClient -Category 5 -State 1 -PrimaryEntity "account" -Columns "name", "clientdata";
``` 


```Powershell 
$definitions = Get-XrmWorkflows -XrmClient $xrmClient -Type 1 -Name "Contoso*";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmWorkflows.md


