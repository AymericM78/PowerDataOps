# Command : `Get-XrmPublisher` 

## Description

**Retrieve publisher record from Microsoft Dataverse.** : Get a publisher by its unique name, or by its customization prefix, with expected columns.
With Prefix, every publisher using that prefix is returned (the platform does not require prefixes to be unique).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
PublisherUniqueName|String|2|true||Publisher unique name to retrieve.
Columns|String[]|3|false|@("publisherid", "uniquename", "friendlyname", "customizationprefix", "customizationoptionvalueprefix", "description")|Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, customizationprefix, customizationoptionvalueprefix, description)
Prefix|String|named|true||Customization prefix (e.g. "contoso" for columns named contoso_*), instead of PublisherUniqueName.

## Outputs
PSCustomObject. Publisher record (XrmObject).

## Usage

```Powershell 
Get-XrmPublisher [[-XrmClient] <ServiceClient>] [-PublisherUniqueName] <String> [[-Columns] <String[]>] [<CommonParameters>]

Get-XrmPublisher [[-XrmClient] <ServiceClient>] [[-Columns] <String[]>] -Prefix <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
$publisher = Get-XrmPublisher -PublisherUniqueName "contoso";
``` 


```Powershell 
$publisher = Get-XrmPublisher -PublisherUniqueName "contoso" -Columns "publisherid", "friendlyname";
``` 


```Powershell 
$publisher = Get-XrmPublisher -XrmClient $xrmClient -Prefix "cts";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPublisher.md


