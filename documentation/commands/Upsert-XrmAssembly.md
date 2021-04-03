# Command : `Upsert-XrmAssembly` 

## Description

**Create or update plugin / workflow assembly.** : Add new or update existing assembly content from local dll file.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
AssemblyPath|String|2|true||Full file path to dll.
SolutionUniqueName|String|3|false||Microsoft Dataverse solution unique name where to add new assembly.
IsolationMode|Int32|4|false|2|Specify if assembly will be deploy in sandbox or not. (Default = 2 | 1 = Not sandboxed, 2 = Sandbox)
SourceType|Int32|5|false|0|Specify where assembly will be stored. (Default = 0 | 0 = Database, 1 = Disk, 2 = Normal (OnPremise), 3 = AzureWebApp)


## Usage

```Powershell 
Upsert-XrmAssembly [[-XrmClient] <CrmServiceClient>] [-AssemblyPath] <String> [[-SolutionUniqueName] <String>] [[-IsolationMode] <Int32>] [[-SourceType] <Int32>] 
[<CommonParameters>]
``` 


