# Command : `Upsert-XrmView` 

## Description

**Create or update a view in Microsoft Dataverse.** : Upsert a savedquery record (system view) by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|named|true||View (savedquery) Id used as the upsert key.
EntityLogicalName|String|named|true||Table / Entity logical name the view belongs to.
Name|String|named|true||View display name.
Labels|Hashtable|named|true||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). Example: @{ 1033 = "Active accounts"; 1036 = "Comptes actifs" }
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
FetchXml|String|named|true||FetchXml query for the view.
LayoutXml|String|named|true||Layout XML defining column widths and order.
QueryType|Int32|named|false|0|View query type. Default: 0 (public view).
Description|String|named|false||View description.
SolutionUniqueName|String|named|false||Unmanaged solution unique name. When provided, the view is added to this solution.
IsDefault|Boolean|named|false|False|Make the view the default one of its type for the table. With $true, the flag is cleared on the previous default views of the same table and type (the platform keeps it otherwise).
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted savedquery record.

## Usage

```Powershell 
Upsert-XrmView [-XrmClient <ServiceClient>] -Id <Guid> -EntityLogicalName <String> -Name <String> [-LanguageCode <Int32>] -FetchXml <String> -LayoutXml <String> [-QueryType <Int32>] [-Description <String>] [-SolutionUniqueName <String>] [-IsDefault <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]

Upsert-XrmView [-XrmClient <ServiceClient>] -Id <Guid> -EntityLogicalName <String> -Labels <Hashtable> [-LanguageCode <Int32>] -FetchXml <String> -LayoutXml <String> [-QueryType <Int32>] [-Description <String>] [-SolutionUniqueName <String>] [-IsDefault <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Upsert-XrmView -Id $viewId -EntityLogicalName "account" -Name "Active Accounts" -FetchXml $fetchXml -LayoutXml $layoutXml -SolutionUniqueName "MySolution";
``` 


```Powershell 
$ref = Upsert-XrmView -XrmClient $xrmClient -Id $viewId -EntityLogicalName "account" -Name "My Accounts" -FetchXml $fetchXml -LayoutXml $layoutXml -IsDefault $true;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmView.md


