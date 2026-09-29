# Command : `Export-XrmWebResource` 

## Description

**Save the content of a web resource to a file.** : Read a web resource by Id or by name, decode its content and write it under OutputPath.
The file path follows the web resource name, "/" becoming folders (new_/scripts/app.js => OutputPath\new_\scripts\app.js), so that Sync-XrmWebResources can send the folder back.
Raises an error when the web resource does not exist.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|named|true||Web resource unique identifier.
Name|String|named|true||Web resource name (e.g. "new_/scripts/app.js").
OutputPath|String|named|true||Root folder of the file. Created when missing.

## Outputs
System.String. Path of the written file.

## Usage

```Powershell 
Export-XrmWebResource [-XrmClient <ServiceClient>] -Name <String> -OutputPath <String> [<CommonParameters>]

Export-XrmWebResource [-XrmClient <ServiceClient>] -Id <Guid> -OutputPath <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
$path = Export-XrmWebResource -XrmClient $xrmClient -Name "new_/scripts/app.js" -OutputPath "C:\Temp\webresources";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmWebResource.md


