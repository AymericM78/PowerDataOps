# Command : `Add-XrmInstance` 

## Description

**Create new Dataverse instance.** : Provision new dataverse instance with database.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
InstanceDisplayName|String|1|true||Instance friendly name
InstanceDomainName|String|2|true||Instance domain name for instance url (myinstance => myinstance.crm.dynamics1.com)
Location|String|3|true||DataCenter region (France, EMEA, UK, ...)
Sku|String|4|true||Instance type (sandbox or production)
CurrencyCodeName|String|5|true||Name of currency (EUR, ...)
LanguageName|String|6|true||Language name LCID (English = 1033, French = 1036, ...)


## Usage

```Powershell 
Add-XrmInstance [-InstanceDisplayName] <String> [-InstanceDomainName] <String> [-Location] <String> [-Sku] <String> [-CurrencyCodeName] <String> [-LanguageName] 
<String> [<CommonParameters>]
``` 


