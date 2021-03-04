# Command : `Get-XrmBackup` 

## Description

**Retrieve backup infos** : Retrieve a backup from given instance

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
InstanceDomainName|String|1|true||Instance domain name (myinstance => myinstance.crm.dynamics1.com)
BackupLabel|String|2|false||Name of the backup

## Outputs

## Usage

```Powershell 
Get-XrmBackup [-InstanceDomainName] <String> [[-BackupLabel] <String>] [<CommonParameters>]
``` 


