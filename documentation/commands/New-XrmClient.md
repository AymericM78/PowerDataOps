# Command : `New-XrmClient` 

## Description

**Initialize CrmServiceClient instance.** : Create a new connection to Microsoft Dataverse with a connectionstring.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ConnectionString|String|1|false||Connection String to Microsoft Dataverse instance (https://docs.microsoft.com/fr-fr/powerapps/developer/common-data-service/xrm-tooling/use-connection-strings-xrm-tooling-connect)
MaxCrmConnectionTimeOutMinutes|Int32|2|false|2|Specify timeout duration in minutes for connection.
IsEncrypted|Boolean|3|false|False|

## Outputs
Microsoft.Xrm.Tooling.Connector.CrmServiceClient. Microsoft Dataverse connector.

## Usage

```Powershell 
New-XrmClient [[-ConnectionString] <String>] [[-MaxCrmConnectionTimeOutMinutes] <Int32>] [[-IsEncrypted] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md


