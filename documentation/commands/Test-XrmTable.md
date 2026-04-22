# Command : `Test-XrmTable` 

## Description

**Verify whether a Dataverse table exists.** : Return $true when a table/entity metadata record exists for the specified logical name.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|2|true||Table / Entity logical name.
RetrieveAsIfPublished|Boolean|3|false|True|Retrieve metadata as if published. Default: true.

## Outputs
System.Boolean.

## Usage

```Powershell 
Test-XrmTable [[-XrmClient] <ServiceClient>] [-LogicalName] <String> [[-RetrieveAsIfPublished] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Test-XrmTable -LogicalName "account";
``` 


