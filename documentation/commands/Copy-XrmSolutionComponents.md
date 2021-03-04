# Command : `Copy-XrmSolutionComponents` 

## Description

**Copy Solution Components.** : Add all components from source solution to target one.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
SourceSolutionUniqueName|String|2|true||Unmanaged solution unique name where to add components.
TargetSolutionUniqueName|String|3|true||Unmanaged solution unique name where to get components.

## Outputs

## Usage

```Powershell 
Copy-XrmSolutionComponents [[-XrmClient] <CrmServiceClient>] [-SourceSolutionUniqueName] <String> [-TargetSolutionUniqueName] <String> [<CommonParameters>]
``` 


