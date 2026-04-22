# Command : `Publish-XrmDuplicateRule` 

## Description

**Publish a duplicate detection rule.** : Publish (activate) a duplicate detection rule using the PublishDuplicateRule SDK action.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
DuplicateRuleReference|EntityReference|2|true||EntityReference of the duplicaterule record to publish.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The PublishDuplicateRule response containing AsyncOperationId.

## Usage

```Powershell 
Publish-XrmDuplicateRule [[-XrmClient] <ServiceClient>] [-DuplicateRuleReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
$ruleRef = New-XrmEntityReference -LogicalName "duplicaterule" -Id $ruleId;
$response = Publish-XrmDuplicateRule -DuplicateRuleReference $ruleRef;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/publishduplicaterule


