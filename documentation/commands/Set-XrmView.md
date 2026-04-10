# Command : `Set-XrmView` 

## Description

**Update a view in Microsoft Dataverse.** : Update an existing savedquery record (system view).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ViewReference|EntityReference|2|true||EntityReference of the savedquery to update.
Name|String|3|false||Updated view display name.
FetchXml|String|4|false||Updated FetchXml query.
LayoutXml|String|5|false||Updated Layout XML.
Description|String|6|false||Updated description.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated savedquery record.

## Usage

```Powershell 
Set-XrmView [[-XrmClient] <ServiceClient>] [-ViewReference] <EntityReference> [[-Name] <String>] [[-FetchXml] <String>] [[-LayoutXml] <String>] [[-Description] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmView -ViewReference $viewRef -Name "All Active Accounts" -FetchXml $newFetchXml;
``` 


