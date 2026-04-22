# Command : `Update-XrmOptionSetColors` 

## Description

**Update option set value colors.** : Update the color property of option set values for a given picklist attribute using the UpdateOptionValue SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Logical name of the entity that contains the attribute.
AttributeLogicalName|String|3|true||Logical name of the picklist attribute.
Colors|Hashtable|4|true||Hashtable mapping option set integer values to hex color strings (e.g., @{ 1 = "#FF0000"; 2 = "#00FF00" }).
PublishChanges|Boolean|5|false|True|Whether to publish customizations after updating. (Default: true)


## Usage

```Powershell 
Update-XrmOptionSetColors [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-AttributeLogicalName] <String> [-Colors] <Hashtable> 
[[-PublishChanges] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$colors = @{ 100000000 = "#FF5733"; 100000001 = "#33FF57"; 100000002 = "#3357FF" };
Update-XrmOptionSetColors -XrmClient $xrmClient -EntityLogicalName "account" -AttributeLogicalName "statuscode" -Colors $colors;
``` 


