# Command : `Set-XrmOrganizationFeature` 

## Description

**Set Organization Feature.** : Define specific feature for default organization (see : Get-XrmOrganization)

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|
Name|String|2|true||Feature name to set.
Value|String|3|true||Feature value to set.

## Outputs

## Usage

```Powershell 
Set-XrmOrganizationFeature [[-XrmClient] <CrmServiceClient>] [-Name] <String> [-Value] <String> [<CommonParameters>]
``` 


