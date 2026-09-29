# Command : `Set-XrmConnectionReference` 

## Description

**Bind a connection reference to a connection.** : Set the connection of an existing connection reference, found by logical name (e.g. after a solution import, before turning the flows on).
Nothing is written when the connection reference is already bound to this connection. The platform checks that the connection exists for the connector.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|2|true||Connection reference logical name.
ConnectionId|String|3|true||Connection to bind (the connection name, as shown in the connection URL).
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference of the connection reference.

## Usage

```Powershell 
Set-XrmConnectionReference [[-XrmClient] <ServiceClient>] [-LogicalName] <String> [-ConnectionId] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmConnectionReference -XrmClient $xrmClient -LogicalName "new_dataverse" -ConnectionId "4b3b8b5c1a2d4e6f8a9b0c1d2e3f4a5b";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmConnectionReference.md


