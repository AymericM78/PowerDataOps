# Command : `Upsert-XrmSolution` 

## Description

**Create or update an unmanaged solution.** : Find the solution by unique name; create it when missing, else update the given properties.
Creation requires a display name (DisplayName or DisplayNameLabels) and a publisher (PublisherUniqueName or PublisherReference).
With DisplayNameLabels, the display name is also set in each language (SetLocLabels); without DisplayName, the text of the base language (or the lowest language code) is used.
Raises an error when the solution is managed.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
UniqueName|String|2|true||Solution unique name.
DisplayName|String|3|false||Solution display name.
DisplayNameLabels|Hashtable|4|false||Display name by language code (e.g. @{ 1033 = "Core"; 1036 = "Socle" }).
PublisherUniqueName|String|5|false||Publisher unique name.
PublisherReference|EntityReference|6|false||Publisher reference, instead of PublisherUniqueName.
Version|String|7|false||Solution version. (Default at creation: 1.0.0.0)
Description|String|8|false||Solution description.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference of the solution.

## Usage

```Powershell 
Upsert-XrmSolution [[-XrmClient] <ServiceClient>] [-UniqueName] <String> [[-DisplayName] <String>] [[-DisplayNameLabels] <Hashtable>] [[-PublisherUniqueName] <String>] [[-PublisherReference] <EntityReference>] [[-Version] <String>] [[-Description] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$solution = Upsert-XrmSolution -XrmClient $xrmClient -UniqueName "ContosoCore" -DisplayNameLabels @{ 1033 = "Contoso core"; 1036 = "Socle Contoso" } -PublisherUniqueName "contoso" -Version "1.2.0.0";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmSolution.md


