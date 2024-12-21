# Command : `Get-XrmTheme` 

## Description

**Retrieve theme record.** : Get theme by its name with expected columns.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||
Columns|String[]|3|false|*|Specify expected columns to retrieve. (Default : All columns)


## Usage

```Powershell 
Get-XrmTheme [[-XrmClient] <ServiceClient>] [-Name] <String> [[-Columns] <String[]>] [<CommonParameters>]
``` 


