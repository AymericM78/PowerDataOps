# Command : `Set-XrmInstanceMode` 

## Description

**Enable or disable admin mode on given instance** : Administration mode will prevent users to access to instance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
InstanceDomainName|String|1|true||Instance domain name (myinstance => myinstance.crm.dynamics1.com)
Mode|String|2|true||Admin mode (Normal : users can access / AdminOnly : Only admins can access)

## Outputs

## Usage

```Powershell 
Set-XrmInstanceMode [-InstanceDomainName] <String> [-Mode] <String> [<CommonParameters>]
``` 


