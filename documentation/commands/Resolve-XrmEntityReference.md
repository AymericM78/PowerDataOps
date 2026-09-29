# Command : `Resolve-XrmEntityReference` 

## Description

**Resolve a lookup from column values.** : Find the one row of LogicalName whose columns match Attributes (AND) and return its EntityReference, e.g. to fill a lookup during a data import.
No match raises an error (or returns $null with IfExists); several matches always raise an error.
With Cache, the resolutions (misses included) are stored in the caller's hashtable and reused: pass the same hashtable to every call of an import.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|2|true||Table / Entity logical name of the row to find.
Attributes|Hashtable|3|true||Hashtable of column = value conditions, all required. A $null value matches an empty column; an EntityReference, OptionSetValue or Money value is compared on its id or value.
Cache|Hashtable|4|false||Hashtable owned by the caller, used to store and reuse resolutions. (Default: no cache)
IfExists|SwitchParameter|named|false|False|Return $null when no row matches, instead of raising an error.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference of the matching row.

## Usage

```Powershell 
Resolve-XrmEntityReference [[-XrmClient] <ServiceClient>] [-LogicalName] <String> [-Attributes] <Hashtable> [[-Cache] <Hashtable>] [-IfExists] [<CommonParameters>]
``` 

## Examples

```Powershell 
$accountRef = Resolve-XrmEntityReference -XrmClient $xrmClient -LogicalName "account" -Attributes @{ accountnumber = "A-0042" };
``` 


```Powershell 
$cache = @{};
foreach ($line in $csvLines) {
    $contact = New-XrmEntity -LogicalName "contact" -Attributes @{
        lastname         = $line.LastName;
        parentcustomerid = (Resolve-XrmEntityReference -XrmClient $xrmClient -LogicalName "account" -Attributes @{ accountnumber = $line.AccountNumber } -Cache $cache -IfExists);
    };
    $xrmClient | Add-XrmRecord -Record $contact | Out-Null;
}
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Resolve-XrmEntityReference.md


