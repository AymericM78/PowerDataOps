# Command : `Sync-XrmWebResources` 

## Description

**Synchronize a webresource folder to Microsoft Dataverse.** : Create or update each webresource content based on local directory.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
FolderPath|String|2|true||Full path to directory where webresources are stored.
SolutionUniqueName|String|3|true||Microsoft Dataverse solution unique name where to add new webressource.
SynchronizationMode|String|4|false||Specify synchronization pattern : full or delta.
Full will update all webresources.
Delta will only update changed webresource based on SynchronizationDeltaHours parameter.
SynchronizationDeltaHours|Int32|5|false|4|Use this parameter with SynchronizationMode = Delta, take local files modified during last x hours. (Default : 4 hours)
SupportedExtensions|String[]|6|false|@("*.htm", "*.html", "*.css", "*.js", "*.xml", "*.png", "*.jpg", "*.jpeg", "*.gif", "*.xap", "*.xsl", "*.ico", "*.svg", "*.resx")|Specify file extensions to handle in synchronization process. (Default : htm, html, css, js, xml, png, jpg, jpeg, gif, xap, xsl, ico, svg, resx)


## Usage

```Powershell 
Sync-XrmWebResources [[-XrmClient] <CrmServiceClient>] [-FolderPath] <String> [-SolutionUniqueName] <String> [[-SynchronizationMode] <String>] 
[[-SynchronizationDeltaHours] <Int32>] [[-SupportedExtensions] <String[]>] [<CommonParameters>]
``` 


