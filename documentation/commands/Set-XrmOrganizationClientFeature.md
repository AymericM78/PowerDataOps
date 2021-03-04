# Command : `Set-XrmOrganizationClientFeature` 

## Description

**Set Organization Client Feature.** : Define specific client feature for default organization (see : Get-XrmOrganization)

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|
Name|String|2|true||Client feature name to set.
Value|String|3|true||Client feature value to set.

## Outputs

## Usage

```Powershell 
Set-XrmOrganizationClientFeature [[-XrmClient] <CrmServiceClient>] [-Name] <String> [-Value] <String> [<CommonParameters>]
``` 


