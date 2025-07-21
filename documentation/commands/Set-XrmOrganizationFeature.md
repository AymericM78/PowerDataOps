# Command : `Set-XrmOrganizationFeature` 

## Description

**Set Organization Feature.** : Define specific feature for default organization (see : Get-XrmOrganization)

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|
Name|String|2|true||Feature name to set.
Value|String|3|true||Feature value to set.


## Usage

```Powershell 
Set-XrmOrganizationFeature [[-XrmClient] <ServiceClient>] [-Name] <String> [-Value] <String> [<CommonParameters>]
``` 


