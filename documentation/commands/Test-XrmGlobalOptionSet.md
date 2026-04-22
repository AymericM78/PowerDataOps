# Command : `Test-XrmGlobalOptionSet` 

## Description

**Verify whether a Dataverse global option set exists.** : Return $true when a global option set exists for the specified name.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Global option set name.
RetrieveAsIfPublished|Boolean|3|false|True|Retrieve metadata as if published. Default: true.

## Outputs
System.Boolean.

## Usage

```Powershell 
Test-XrmGlobalOptionSet [[-XrmClient] <ServiceClient>] [-Name] <String> [[-RetrieveAsIfPublished] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Test-XrmGlobalOptionSet -Name "new_status";
``` 


