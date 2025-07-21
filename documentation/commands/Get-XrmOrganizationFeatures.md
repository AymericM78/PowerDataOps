# Command : `Get-XrmOrganizationFeatures` 

## Description

**Get Organization Features** : Retrieve all or specified features from default organization (see : Get-XrmOrganization)

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|
Name|String|2|false||Feature name to retrieve.


## Usage

```Powershell 
Get-XrmOrganizationFeatures [[-XrmClient] <ServiceClient>] [[-Name] <String>] [<CommonParameters>]
``` 


