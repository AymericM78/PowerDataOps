# Working with data thanks to `PowerDataOps` Module

## Important

PowerDataOps module retrieve Dataverse record as object to increase data manipulation.
But if you need to create, update, remove records you need to provide Entity type.
An object contains Record property to keep the Entity content.
Complex properties like Money, OptionSetValue, EntityReference, ... are stored in attributename_Value property.

## Overview

This sample show how to :

- Connect to Microsoft Dataverse
- Create a record
- Retrieve all records and output in a gridview
- Update a record
- Retrieve a specific record
- Delete record

## Sample code

```Powershell

Import-Module PowerDataOps

# Script parameters : must be 'your' values
$url = "https://contoso.crm12.dynamics.com";
$clientId = "c6511040-5c20-4649-854e-dd78edfea759";
$clientSecret = "ds515sqd15d1q";

# Initialize connection
$connectionString = "AuthType=ClientSecret;Url=$url;ClientId=$clientId;ClientSecret=$clientSecret;"
$xrmClient = New-XrmClient -ConnectionString $connectionString;

# Create a new account
$account = New-XrmEntity -LogicalName "account" -Attributes @{
    "name" = "Contoso";
    "revenue" = New-XrmMoney -Value 123456.78;
    "industrycode" = New-XrmOptionSetValue -Value 37;
}
$account.Id = Add-XrmRecord -Record $account;

# Retrieve all accounts with all columns where name starts with D and created in last 20 months
# * for `-Columns` parameters is not recommended for performance purposes, you can also specify each column separated with comma
# Intellisense is enable for columns and condition operators
$queryAccounts = New-XrmQueryExpression -LogicalName "account" -Columns "*" `
               | Add-XrmQueryCondition -Field "name" -Condition Like -Values "D%" `
               | Add-XrmQueryCondition -Field "createdon" -Condition LastXMonths -Values 20;
$accounts = Get-XrmMultipleRecords -Query $queryAccounts;

# Then output all accounts in a grid and select one
$selectedAccount = $accounts | Select-Object id, name, createdon | Out-GridView -OutputMode Single;

# Update created account and set selected account as parent
$accountUpdate = New-XrmEntity -LogicalName "account" -Id $account.Id -Attributes @{
    "parentaccountid" = (New-XrmEntityReference -LogicalName "account" -Id $selectedAccount.Id)
}
$accountUpdate | Update-XrmRecord;

# Retrieve an account from its name
$contosoAccount = Get-XrmRecord -LogicalName "account" -AttributeName "name" -Value "Contoso" -Columns "revenue";
# Display revenue info
$contosoAccount.revenue;

# Remove contoso account
Remove-XrmRecord -Record $contosoAccount.Record;

```
