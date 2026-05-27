# Command : `Add-XrmView` 

## Description

**Create a new view in Microsoft Dataverse.** : Create a new savedquery record (system view).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|named|true||Table / Entity logical name the view belongs to.
Name|String|named|true||View display name.
Labels|Hashtable|named|true||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). Example: @{ 1033 = "Active accounts"; 1036 = "Comptes actifs" }
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
FetchXml|String|named|true||FetchXml query for the view.
LayoutXml|String|named|true||Layout XML defining column widths and order.
QueryType|Int32|named|false|0|View query type. Default: 0 (public view).
Description|String|named|false||View description.
SolutionUniqueName|String|named|false||Unmanaged solution unique name. When provided, the created view is automatically added to this solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created savedquery record.

## Usage

```Powershell 
Add-XrmView [-XrmClient <ServiceClient>] -EntityLogicalName <String> -Name <String> [-LanguageCode <Int32>] -FetchXml <String> -LayoutXml <String> 
[-QueryType <Int32>] [-Description <String>] [-SolutionUniqueName <String>] [<CommonParameters>]

Add-XrmView [-XrmClient <ServiceClient>] -EntityLogicalName <String> -Labels <Hashtable> [-LanguageCode <Int32>] -FetchXml <String> -LayoutXml <String> 
[-QueryType <Int32>] [-Description <String>] [-SolutionUniqueName <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Add-XrmView -EntityLogicalName "account" -Name "Active Accounts" -FetchXml $fetchXml -LayoutXml $layoutXml;
$ref = Add-XrmView -EntityLogicalName "account" -Name "Active Accounts" -FetchXml $fetchXml -LayoutXml $layoutXml -SolutionUniqueName "MySolution";
``` 


```Powershell 
$ref = Add-XrmView -EntityLogicalName "account" -Labels @{ 1033 = "Active accounts"; 1036 = "Comptes actifs" } -LanguageCode 1036 -FetchXml $fetchXml -LayoutXml $layoutXml;
``` 


