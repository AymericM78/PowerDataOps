# Command : `Get-XrmOrganizationClientFeatures` 

## Description

**Get Organization Client Features.** : Retrieve all or specified client features from default organization (see : Get-XrmOrganization)

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|
Name|String|2|false||Client feature name to retrieve.


## Usage

```Powershell 
Get-XrmOrganizationClientFeatures [[-XrmClient] <ServiceClient>] [[-Name] <String>] [<CommonParameters>]
``` 


