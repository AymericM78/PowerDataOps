# Command : `Upsert-XrmWebResource` 

## Description

**Create or update webresource.** : Check if webresource exists or not. If not exists create it and add it to specified solution.
If webresource exists, compare content and update it if different.
By default, returns the webresource id only when it was created or updated (to build a publish request), and skips silently a file whose name does not start with the prefix.
With PassThru, always returns an object: Id, Name, Changed, Skipped.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
FilePath|String|2|true||Local webresource file path.
SolutionUniqueName|String|3|true||Microsoft Dataverse solution unique name where to add new webressource.
Prefix|String|4|false||Publisher customization prefix for newly created webresource. (Default: prefix of the solution publisher)
DisplayName|String|5|false||Webresource display name. (Default: file name)
PassThru|SwitchParameter|named|false|False|Always return an object: Id, Name, Changed (created or updated), Skipped (name without the prefix, nothing done).

## Outputs
Guid. The webresource id, when created or updated. With PassThru: PSCustomObject (Id, Name, Changed, Skipped).

## Usage

```Powershell 
Upsert-XrmWebResource [[-XrmClient] <ServiceClient>] [-FilePath] <String> [-SolutionUniqueName] <String> [[-Prefix] <String>] [[-DisplayName] <String>] [-PassThru] [<CommonParameters>]
``` 

## Examples

```Powershell 
$webResourceId = Upsert-XrmWebResource -XrmClient $xrmClient -FilePath "C:\Sources\WebResources\new_\scripts\account.js" -SolutionUniqueName "MySolution";
``` 


```Powershell 
$result = Upsert-XrmWebResource -XrmClient $xrmClient -FilePath $path -SolutionUniqueName "MySolution" -PassThru;
if ($result.Changed) { Publish-XrmComponent -XrmClient $xrmClient -ComponentName "webresource" -ComponentId $result.Id; }
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmWebResource.md


