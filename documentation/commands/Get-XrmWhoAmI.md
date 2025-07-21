# Command : `Get-XrmWhoAmI` 

## Description

**Retrieve current user id.** : Get system user unique identifier.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)


## Usage

```Powershell 
Get-XrmWhoAmI [[-XrmClient] <ServiceClient>] [<CommonParameters>]
``` 


