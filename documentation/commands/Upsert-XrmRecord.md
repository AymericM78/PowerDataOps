# Command : `Upsert-XrmRecord` 

## Description

**Upsert entity record in Dataverse.** : Upsert row (entity record) from Microsoft Dataverse table.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Record|Entity|2|true||Record (row) to Upsert.
BypassCustomPluginExecution|SwitchParameter|named|false|False|Specify wether involved plugins should be triggered or not during this operation. (Default: False)

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The Upsert response.

## Usage

```Powershell 
Upsert-XrmRecord [[-XrmClient] <ServiceClient>] [-Record] <Entity> [-BypassCustomPluginExecution] [<CommonParameters>]
``` 

## Examples

```Powershell 
$record = New-XrmEntity -LogicalName "account" -Attributes @{ "name" = "Contoso" };
Upsert-XrmRecord -Record $record;
``` 


