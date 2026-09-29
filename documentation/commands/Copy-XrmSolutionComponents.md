# Command : `Copy-XrmSolutionComponents` 

## Description

**Copy Solution Components.** : Add all components from source solution to target one.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SourceSolutionUniqueName|String|2|true||Unmanaged solution unique name where to add components.
TargetSolutionUniqueName|String|3|true||Unmanaged solution unique name where to get components.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||


## Usage

```Powershell 
Copy-XrmSolutionComponents [[-XrmClient] <ServiceClient>] [-SourceSolutionUniqueName] <String> [-TargetSolutionUniqueName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 


