# Command : `Test-XrmPublisher` 

## Description

**Verify whether a Dataverse publisher exists.** : Return $true when a publisher exists for the specified unique name.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
PublisherUniqueName|String|2|true||Publisher unique name to check.

## Outputs
System.Boolean.

## Usage

```Powershell 
Test-XrmPublisher [[-XrmClient] <ServiceClient>] [-PublisherUniqueName] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
Test-XrmPublisher -PublisherUniqueName "contoso";
``` 


