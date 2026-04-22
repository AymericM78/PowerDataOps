# Command : `Add-XrmView` 

## Description

**Create a new view in Microsoft Dataverse.** : Create a new savedquery record (system view).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name the view belongs to.
Name|String|3|true||View display name.
FetchXml|String|4|true||FetchXml query for the view.
LayoutXml|String|5|true||Layout XML defining column widths and order.
QueryType|Int32|6|false|0|View query type. Default: 0 (public view).
Description|String|7|false||View description.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created savedquery record.

## Usage

```Powershell 
Add-XrmView [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-Name] <String> [-FetchXml] <String> [-LayoutXml] <String> [[-QueryType] 
<Int32>] [[-Description] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Add-XrmView -EntityLogicalName "account" -Name "Active Accounts" -FetchXml $fetchXml -LayoutXml $layoutXml;
``` 


