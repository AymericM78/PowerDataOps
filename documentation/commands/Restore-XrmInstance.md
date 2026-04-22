# Command : `Restore-XrmInstance` 

## Description

**Restore instance at given time.** : Restore a backup of given instance to itself or another instance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
SourceInstanceDomainName|String|1|true||Instance domain name (myinstance => myinstance.crm.dynamics1.com) that you want to restore
TargetInstanceDomainName|String|2|false||
TargetInstanceNewDisplayName|String|3|false||
TargetInstanceSecurityGroupId|Guid|4|false||AAD Security Group ID to define on target instance to restrict users access
RestoreTimeUtc|DateTime|5|false||Date time in UTC of restore point
BackupLabel|String|6|false||Name of the backup


## Usage

```Powershell 
Restore-XrmInstance [-SourceInstanceDomainName] <String> [[-TargetInstanceDomainName] <String>] [[-TargetInstanceNewDisplayName] <String>] 
[[-TargetInstanceSecurityGroupId] <Guid>] [[-RestoreTimeUtc] <DateTime>] [[-BackupLabel] <String>] [<CommonParameters>]
``` 


