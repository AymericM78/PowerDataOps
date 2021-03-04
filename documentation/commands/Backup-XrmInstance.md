# Command : `Backup-XrmInstance` 

## Description

**Backup instance** : Add a backup for given instance

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
InstanceDomainName|String|1|true||Instance domain name (myinstance => myinstance.crm.dynamics1.com)
BackupLabel|String|2|true||Name of the backup
BackupDescription|String|3|false||Backup description


## Usage

```Powershell 
Backup-XrmInstance [-InstanceDomainName] <String> [-BackupLabel] <String> [[-BackupDescription] <String>] [<CommonParameters>]
``` 


