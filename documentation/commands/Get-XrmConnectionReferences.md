# Command : `Get-XrmConnectionReferences` 

## Description

**Retrieve connection references.** : Get connection reference rows (connectionreference), optionally filtered by logical name or connector.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|2|false||Connection reference logical name (connectionreferencelogicalname). (Default: all)
ConnectorId|String|3|false||Connector, as a full id ("/providers/Microsoft.PowerApps/apis/shared_commondataserviceforapps") or its last segment ("shared_commondataserviceforapps"). (Default: all)
Columns|String[]|4|false|@("connectionreferencelogicalname", "connectionreferencedisplayname", "connectorid", "connectionid", "statecode")|Columns to return. (Default: connectionreferencelogicalname, connectionreferencedisplayname, connectorid, connectionid, statecode)

## Outputs
PSCustomObject[]. Connection reference rows (XrmObject).

## Usage

```Powershell 
Get-XrmConnectionReferences [[-XrmClient] <ServiceClient>] [[-LogicalName] <String>] [[-ConnectorId] <String>] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$references = Get-XrmConnectionReferences -XrmClient $xrmClient -ConnectorId "shared_commondataserviceforapps";
$unbound = $references | Where-Object { -not $_.connectionid };
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmConnectionReferences.md


