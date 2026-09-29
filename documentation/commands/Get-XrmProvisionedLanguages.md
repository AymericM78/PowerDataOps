# Command : `Get-XrmProvisionedLanguages` 

## Description

**Retrieve the languages provisioned in the organization.** : Get the language codes (LCID) enabled in the organization (RetrieveProvisionedLanguages), in ascending order, or with the base language first.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
BaseFirst|SwitchParameter|named|false|False|Put the base language of the organization (organization.languagecode) first.

## Outputs
System.Int32[]. Language codes.

## Usage

```Powershell 
Get-XrmProvisionedLanguages [[-XrmClient] <ServiceClient>] [-BaseFirst] [<CommonParameters>]
``` 

## Examples

```Powershell 
$languages = Get-XrmProvisionedLanguages -XrmClient $xrmClient -BaseFirst;
$baseLanguage = $languages[0];
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmProvisionedLanguages.md


