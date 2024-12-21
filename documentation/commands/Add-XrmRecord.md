# Command : `Add-XrmRecord` 

## Description

**Create entity record in Microsoft Dataverse.** : Add a new row in Microsoft Dataverse table and return created ID (Uniqueidentifier).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Record|Entity|2|true||Record information to add. (Entity)
BypassCustomPluginExecution|SwitchParameter|named|false|False|Specify wether involved plugins should be triggered or not during this operation. (Default: False)

## Outputs
Guid. Newly created record identified.

## Usage

```Powershell 
Add-XrmRecord [[-XrmClient] <ServiceClient>] [-Record] <Entity> [-BypassCustomPluginExecution] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$account = New-XrmEntity -LogicalName "account" -Attributes @{
    "name" = "Contoso";
    "revenue" = New-XrmMoney -Value 123456.78;
    "industrycode" = New-XrmOptionSetValue -Value 37;
}
$account.Id = Add-XrmRecord -XrmClient $xrmClient -Record $account;
``` 

## More informations

System.Object[]


