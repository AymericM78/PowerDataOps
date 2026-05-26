# Command : `Upsert-XrmView` 

## Description

**Create or update a view in Microsoft Dataverse.** : Upsert a savedquery record (system view) by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|2|true||View (savedquery) Id used as the upsert key.
EntityLogicalName|String|3|true||Table / Entity logical name the view belongs to.
Name|String|4|true||View display name.
FetchXml|String|5|true||FetchXml query for the view.
LayoutXml|String|6|true||Layout XML defining column widths and order.
QueryType|Int32|7|false|0|View query type. Default: 0 (public view).
Description|String|8|false||View description.
SolutionUniqueName|String|9|false||Unmanaged solution unique name. When provided, the view is added to this solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted savedquery record.

## Usage

```Powershell 
Upsert-XrmView [[-XrmClient] <ServiceClient>] [-Id] <Guid> [-EntityLogicalName] <String> [-Name] <String> [-FetchXml] <String> [-LayoutXml] <String> 
[[-QueryType] <Int32>] [[-Description] <String>] [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Upsert-XrmView -Id $viewId -EntityLogicalName "account" -Name "Active Accounts" -FetchXml $fetchXml -LayoutXml $layoutXml -SolutionUniqueName "MySolution";
``` 


