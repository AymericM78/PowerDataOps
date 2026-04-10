# Command : `Remove-XrmView` 

## Description

**Delete a view from Microsoft Dataverse.** : Delete a savedquery record (system view).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ViewReference|EntityReference|2|true||EntityReference of the savedquery to delete.

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmView [[-XrmClient] <ServiceClient>] [-ViewReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmView -ViewReference $viewRef;
``` 


