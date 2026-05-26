# Command : `Get-XrmCommands` 

## Description

**Retrieve command records from Microsoft Dataverse.** : Get appaction records (command bar buttons) optionally filtered by entity context.
Use -Unpublished to also retrieve commands that are in draft state.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|false||Table / Entity logical name to filter commands by context entity. Optional.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)
Unpublished|SwitchParameter|named|false|False|When specified, uses RetrieveUnpublishedMultiple to include commands in draft (unpublished) state.
Without this switch only published commands are returned.

## Outputs
PSCustomObject[]. Array of appaction records (XrmObject).

## Usage

```Powershell 
Get-XrmCommands [[-XrmClient] <ServiceClient>] [[-EntityLogicalName] <String>] [[-Columns] <String[]>] [-Unpublished] [<CommonParameters>]
``` 

## Examples

```Powershell 
$commands = Get-XrmCommands;
$accountCommands = Get-XrmCommands -EntityLogicalName "account";
``` 


```Powershell 
# Include unpublished drafts
$allCommands = Get-XrmCommands -Unpublished;
``` 


