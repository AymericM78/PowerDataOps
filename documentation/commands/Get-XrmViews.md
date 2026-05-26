# Command : `Get-XrmViews` 

## Description

**Retrieve savedquery records.** : Get all saved query according to entity name and predefined columns.
Use -Unpublished to also retrieve views that are in draft state.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Gets or sets the entity name in order to filter views name.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)
Unpublished|SwitchParameter|named|false|False|When specified, uses RetrieveUnpublishedMultiple to include views in draft (unpublished) state.
Without this switch only published views are returned.

## Outputs
PSCustomObject[]. Array of savedquery records (XrmObject).

## Usage

```Powershell 
Get-XrmViews [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [[-Columns] <String[]>] [-Unpublished] [<CommonParameters>]
``` 

## Examples

```Powershell 
$views = Get-XrmViews -EntityLogicalName "account";
``` 


```Powershell 
# Include unpublished drafts
$allViews = Get-XrmViews -EntityLogicalName "account" -Unpublished;
``` 


