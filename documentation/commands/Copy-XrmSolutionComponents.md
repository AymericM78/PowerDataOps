# Command : `Copy-XrmSolutionComponents` 

## Description

**Copy Solution Components.** : Add all components from source solution to target one.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
SourceSolutionUniqueName|String|2|true||Unmanaged solution unique name where to add components.
TargetSolutionUniqueName|String|3|true||Unmanaged solution unique name where to get components.


## Usage

```Powershell 
Copy-XrmSolutionComponents [[-XrmClient] <ServiceClient>] [-SourceSolutionUniqueName] <String> [-TargetSolutionUniqueName] <String> [<CommonParameters>]
``` 


