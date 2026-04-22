# Command : `Set-XrmGlobalOptionSet` 

## Description

**Update a global option set in Microsoft Dataverse.** : Update an existing global option set using UpdateOptionSetRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
OptionSetMetadata|OptionSetMetadataBase|2|true||The OptionSetMetadata object with updated properties.
SolutionUniqueName|String|3|false||Solution unique name context for the update.
MergeLabels|Boolean|4|false|True|Whether to merge labels. Default: true.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateOptionSet response.

## Usage

```Powershell 
Set-XrmGlobalOptionSet [[-XrmClient] <ServiceClient>] [-OptionSetMetadata] <OptionSetMetadataBase> [[-SolutionUniqueName] <String>] [[-MergeLabels] 
<Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$os = Get-XrmGlobalOptionSet -Name "new_priority";
$os.DisplayName = New-XrmLabel -Text "Priority Level";
Set-XrmGlobalOptionSet -OptionSetMetadata $os;
``` 


