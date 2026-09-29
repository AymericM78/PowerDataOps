# Command : `Set-XrmView` 

## Description

**Update a view in Microsoft Dataverse.** : Update an existing savedquery record (system view).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ViewReference|EntityReference|2|true||EntityReference of the savedquery to update.
Name|String|3|false||Updated view display name.
Labels|Hashtable|4|false||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). -Name takes precedence if both are provided.
LanguageCode|Int32|5|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
FetchXml|String|6|false||Updated FetchXml query.
LayoutXml|String|7|false||Updated Layout XML.
Description|String|8|false||Updated description.
SolutionUniqueName|String|9|false||Unmanaged solution unique name. When provided, the updated view is automatically added to this solution.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated savedquery record.

## Usage

```Powershell 
Set-XrmView [[-XrmClient] <ServiceClient>] [-ViewReference] <EntityReference> [[-Name] <String>] [[-Labels] <Hashtable>] [[-LanguageCode] <Int32>] [[-FetchXml] <String>] [[-LayoutXml] <String>] [[-Description] <String>] [[-SolutionUniqueName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmView -ViewReference $viewRef -Name "All Active Accounts" -FetchXml $newFetchXml;
Set-XrmView -ViewReference $viewRef -FetchXml $newFetchXml -SolutionUniqueName "MySolution";
``` 


