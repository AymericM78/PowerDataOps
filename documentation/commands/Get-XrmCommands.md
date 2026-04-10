# Command : `Get-XrmCommands` 

## Description

**Retrieve command records from Microsoft Dataverse.** : Get appaction records (command bar buttons) optionally filtered by entity context.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|false||Table / Entity logical name to filter commands by context entity. Optional.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)

## Outputs
Microsoft.Xrm.Sdk.Entity[]. Array of appaction records.

## Usage

```Powershell 
Get-XrmCommands [[-XrmClient] <ServiceClient>] [[-EntityLogicalName] <String>] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$commands = Get-XrmCommands;
$accountCommands = Get-XrmCommands -EntityLogicalName "account";
``` 


