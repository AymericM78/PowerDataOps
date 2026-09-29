# Command : `Upsert-XrmEnvironmentVariableDefinition` 

## Description

**Create or update an environment variable definition.** : Find the environment variable definition by schema name; create it when missing, else update the given properties (display name, default value, description).
The type is set at creation only. With SolutionUniqueName, the definition is added to the solution (idempotent).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SchemaName|String|2|true||Schema name of the definition, with the publisher prefix (e.g. "new_ApiUrl").
DisplayName|String|3|false||Display name. (Default: SchemaName, at creation)
Type|String|4|false|String|Data type, at creation: String, Number, Boolean, JSON, DataSource, Secret. (Default: String)
DefaultValue|String|5|false||Default value of the variable. An empty string clears it.
Description|String|6|false||Description of the variable.
SolutionUniqueName|String|7|false||Unmanaged solution to add the definition to.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference of the definition.

## Usage

```Powershell 
Upsert-XrmEnvironmentVariableDefinition [[-XrmClient] <ServiceClient>] [-SchemaName] <String> [[-DisplayName] <String>] [[-Type] <String>] [[-DefaultValue] <String>] [[-Description] <String>] [[-SolutionUniqueName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$definition = Upsert-XrmEnvironmentVariableDefinition -XrmClient $xrmClient -SchemaName "new_ApiUrl" -DisplayName "API URL" -DefaultValue "https://api.contoso.com" -SolutionUniqueName "MySolution";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmEnvironmentVariableDefinition.md


