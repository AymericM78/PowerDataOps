# Command : `Upsert-XrmConnectionReference` 

## Description

**Create or update a connection reference.** : Find the connection reference by logical name; create it when missing, else update the given properties.
With SolutionUniqueName, the connection reference is added to the solution (idempotent); its component type is read from the organization (see Get-XrmSolutionComponentType).
The platform checks ConnectionId: the connection must exist for the connector.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|2|true||Connection reference logical name, with the publisher prefix (e.g. "new_sharedcommondataserviceforapps_1a2b3").
DisplayName|String|3|false||Display name. (Default: LogicalName, at creation)
ConnectorId|String|4|false||Connector, as a full id ("/providers/Microsoft.PowerApps/apis/shared_office365") or its last segment ("shared_office365"). Required at creation.
ConnectionId|String|5|false||Connection to bind (the connection name, as shown in the connection URL).
Description|String|6|false||Description of the connection reference.
SolutionUniqueName|String|7|false||Unmanaged solution to add the connection reference to.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference of the connection reference.

## Usage

```Powershell 
Upsert-XrmConnectionReference [[-XrmClient] <ServiceClient>] [-LogicalName] <String> [[-DisplayName] <String>] [[-ConnectorId] <String>] [[-ConnectionId] <String>] [[-Description] <String>] [[-SolutionUniqueName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$reference = Upsert-XrmConnectionReference -XrmClient $xrmClient -LogicalName "new_dataverse" -DisplayName "Dataverse" -ConnectorId "shared_commondataserviceforapps" -SolutionUniqueName "MySolution";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmConnectionReference.md


