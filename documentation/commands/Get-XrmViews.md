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
QueryType|Int32[]|4|false||View types to keep (savedquery.querytype, see the SavedQueryQueryType values): 0 public view, 1 advanced find, 2 associated (subgrid), 4 quick find, 64 lookup... (Default: all)
IsDefault|SwitchParameter|named|false|False|Keep the default views only (isdefault true): with QueryType 0, the default public view of the table.

## Outputs
PSCustomObject[]. Array of savedquery records (XrmObject).

## Usage

```Powershell 
Get-XrmViews [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [[-Columns] <String[]>] [-Unpublished] [[-QueryType] <Int32[]>] [-IsDefault] [<CommonParameters>]
``` 

## Examples

```Powershell 
$views = Get-XrmViews -EntityLogicalName "account";
``` 


```Powershell 
# Include unpublished drafts
$allViews = Get-XrmViews -EntityLogicalName "account" -Unpublished;
``` 


```Powershell 
# Default public view and quick find view
$defaultView = Get-XrmViews -XrmClient $xrmClient -EntityLogicalName "account" -QueryType 0 -IsDefault -Columns "name", "fetchxml";
$quickFind = Get-XrmViews -XrmClient $xrmClient -EntityLogicalName "account" -QueryType 4 -Columns "name";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmViews.md


