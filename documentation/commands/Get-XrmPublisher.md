# Command : `Get-XrmPublisher` 

## Description

**Retrieve publisher record from Microsoft Dataverse.** : Get a publisher by its unique name with expected columns.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
PublisherUniqueName|String|2|true||Publisher unique name to retrieve.
Columns|String[]|3|false|@("publisherid", "uniquename", "friendlyname", "customizationprefix", "customizationoptionvalueprefix", "description")|Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, customizationprefix, customizationoptionvalueprefix, description)

## Outputs
Microsoft.Xrm.Sdk.Entity. Publisher record.

## Usage

```Powershell 
Get-XrmPublisher [[-XrmClient] <ServiceClient>] [-PublisherUniqueName] <String> [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$publisher = Get-XrmPublisher -PublisherUniqueName "contoso";
``` 


```Powershell 
$publisher = Get-XrmPublisher -PublisherUniqueName "contoso" -Columns "publisherid", "friendlyname";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/reference/entities/publisher


