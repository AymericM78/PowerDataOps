# Command : `Add-XrmAlternateKey` 

## Description

**Create an alternate key on a Microsoft Dataverse table.** : Add a new entity key using CreateEntityKeyRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
EntityKeyMetadata|EntityKeyMetadata|3|true||The EntityKeyMetadata object defining the alternate key.
SolutionUniqueName|String|4|false||Solution unique name to add the alternate key to.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The CreateEntityKey response.

## Usage

```Powershell 
Add-XrmAlternateKey [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-EntityKeyMetadata] <EntityKeyMetadata> [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$key = [Microsoft.Xrm.Sdk.Metadata.EntityKeyMetadata]::new();
$key.LogicalName = "new_accountcode";
$key.DisplayName = New-XrmLabel -Text "Account Code";
$key.KeyAttributes = @("new_code");
Add-XrmAlternateKey -EntityLogicalName "account" -EntityKeyMetadata $key;
``` 


