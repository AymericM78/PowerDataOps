# Command : `Get-XrmRecord` 

## Description

**Search for record with simple query.** : Get specific row (Entity record) according to given id, key, or attribute.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
LogicalName|String|2|true||Table / Entity logical name.
Key|String|3|false||Specify alternate key attribute name to search.
AttributeName|String|4|false||Specify attribute name to search.
Value|Object|5|true||Specify key or attribute value to search.
Use Id to specify row (entity record) unique identifier
Columns|String[]|6|false||Specify row (entity record) columns to return. (array)

## Outputs
Custom Object. Row (= Entity record) is converted to custom object to simplify data operations.

## Usage

```Powershell 
Get-XrmRecord [[-XrmClient] <CrmServiceClient>] [-LogicalName] <String> [[-Key] <String>] [[-AttributeName] <String>] [-Value] <Object> [[-Columns] <String[]>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$contosoAccount = Get-XrmRecord -XrmClient $xrmClient -LogicalName "account" -AttributeName "name" -Value "Contoso" -Columns "revenue";
Write-Host $contosoAccount.revenue;
``` 

## More informations

Samples: https://github.com/AymericM78/PowerDataOps/blob/main/documentation/samples/Working%20with%20data.md


