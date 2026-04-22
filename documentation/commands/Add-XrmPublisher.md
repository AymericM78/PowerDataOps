# Command : `Add-XrmPublisher` 

## Description

**Create a new publisher in Microsoft Dataverse.** : Create a publisher record with the specified unique name, display name, prefix, and option value prefix.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
UniqueName|String|2|true||Publisher unique name. Must be lowercase, no spaces.
DisplayName|String|3|true||Publisher display name (friendly name).
Prefix|String|4|true||Customization prefix for the publisher (e.g., "contoso"). Must be 2-8 lowercase letters.
OptionValuePrefix|Int32|5|true|0|Option value prefix number for the publisher. Must be between 10000 and 99999.
Description|String|6|false||Optional description for the publisher.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Created publisher reference.

## Usage

```Powershell 
Add-XrmPublisher [[-XrmClient] <ServiceClient>] [-UniqueName] <String> [-DisplayName] <String> [-Prefix] <String> [-OptionValuePrefix] <Int32> 
[[-Description] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$publisher = Add-XrmPublisher -UniqueName "contoso" -DisplayName "Contoso Ltd" -Prefix "cts" -OptionValuePrefix 28100;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/reference/entities/publisher


