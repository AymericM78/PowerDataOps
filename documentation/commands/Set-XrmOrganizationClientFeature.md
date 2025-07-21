# Command : `Set-XrmOrganizationClientFeature` 

## Description

**Set Organization Client Feature.** : Define specific client feature for default organization (see : Get-XrmOrganization)

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|
Name|String|2|true||Client feature name to set.
Value|String|3|true||Client feature value to set.


## Usage

```Powershell 
Set-XrmOrganizationClientFeature [[-XrmClient] <ServiceClient>] [-Name] <String> [-Value] <String> [<CommonParameters>]
``` 


