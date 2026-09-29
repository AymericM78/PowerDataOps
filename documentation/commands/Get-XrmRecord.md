# Command : `Get-XrmRecord` 

## Description

**Search for record with simple query.** : Get specific row (Entity record) according to given id, key, attribute, or set of attributes.
With AttributeName or Attributes, the first matching row is returned ($null when none matches); Unique raises an error when several rows match.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|2|true||Table / Entity logical name.
Key|String|3|false||Specify alternate key attribute name to search.
AttributeName|String|4|false||Specify attribute name to search.
Value|Object|5|true||Specify key or attribute value to search.
Use Id to specify row (entity record) unique identifier
Columns|String[]|6|false||Specify row (entity record) columns to return. (array)
Attributes|Hashtable|named|true||Hashtable of column = value conditions, all required (AND). A $null value matches an empty column; an EntityReference, OptionSetValue or Money value is compared on its id or value.
IfExists|SwitchParameter|named|false|False|Return $null when the row does not exist (search by id or key), instead of raising an error.
Unique|SwitchParameter|named|false|False|With AttributeName or Attributes: raise an error when more than one row matches, instead of returning the first one.
AsEntity|SwitchParameter|named|false|False|Return the SDK Entity instead of a converted custom object.

## Outputs
Custom Object. Row (= Entity record) is converted to custom object to simplify data operations. With AsEntity: Microsoft.Xrm.Sdk.Entity.

## Usage

```Powershell 
Get-XrmRecord [[-XrmClient] <ServiceClient>] [-LogicalName] <String> [[-Key] <String>] [[-AttributeName] <String>] [-Value] <Object> [[-Columns] <String[]>] [-IfExists] [-Unique] [-AsEntity] [<CommonParameters>]

Get-XrmRecord [[-XrmClient] <ServiceClient>] [-LogicalName] <String> [[-Columns] <String[]>] -Attributes <Hashtable> [-IfExists] [-Unique] [-AsEntity] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$contosoAccount = Get-XrmRecord -XrmClient $xrmClient -LogicalName "account" -AttributeName "name" -Value "Contoso" -Columns "revenue";
Write-Host $contosoAccount.revenue;
``` 


```Powershell 
$contact = Get-XrmRecord -XrmClient $xrmClient -LogicalName "contact" -Attributes @{ firstname = "John"; lastname = "Doe"; parentcustomerid = $accountRef } -Unique;
``` 


```Powershell 
$account = Get-XrmRecord -XrmClient $xrmClient -LogicalName "account" -Id $accountId -Columns "name" -IfExists;
if (-not $account) { Write-Host "Deleted meanwhile"; }
``` 

## More informations

System.Object[]


