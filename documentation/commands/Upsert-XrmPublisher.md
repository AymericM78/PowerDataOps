# Command : `Upsert-XrmPublisher` 

## Description

**Create or update a publisher.** : Find the publisher by unique name; create it when missing, else update the given properties.
Creation requires a display name (DisplayName or DisplayNameLabels), Prefix and OptionValuePrefix.
With DisplayNameLabels, the display name is also set in each language (SetLocLabels); without DisplayName, the text of the base language (or the lowest language code) is used.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
UniqueName|String|2|true||Publisher unique name.
DisplayName|String|3|false||Publisher display name.
DisplayNameLabels|Hashtable|4|false||Display name by language code (e.g. @{ 1033 = "Contoso"; 1036 = "Contoso FR" }).
Prefix|String|5|false||Customization prefix (2 to 8 lowercase letters).
OptionValuePrefix|Int32|6|false|0|Option value prefix (10000 to 99999).
Description|String|7|false||Publisher description.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference of the publisher.

## Usage

```Powershell 
Upsert-XrmPublisher [[-XrmClient] <ServiceClient>] [-UniqueName] <String> [[-DisplayName] <String>] [[-DisplayNameLabels] <Hashtable>] [[-Prefix] <String>] [[-OptionValuePrefix] <Int32>] [[-Description] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$publisher = Upsert-XrmPublisher -XrmClient $xrmClient -UniqueName "contoso" -DisplayNameLabels @{ 1033 = "Contoso"; 1036 = "Contoso" } -Prefix "cts" -OptionValuePrefix 12345;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmPublisher.md


