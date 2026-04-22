# Command : `Add-XrmSolution` 

## Description

**Create a new unmanaged solution in Microsoft Dataverse.** : Create an unmanaged solution with the specified unique name, display name, version, and publisher.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
UniqueName|String|2|true||Solution unique name. Must be lowercase, no spaces.
DisplayName|String|3|true||Solution display name (friendly name).
PublisherReference|EntityReference|4|true||EntityReference to the publisher record that owns this solution.
Version|String|5|false|1.0.0.0|Solution version string (e.g., "1.0.0.0"). Default: "1.0.0.0".
Description|String|6|false||Optional description for the solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Created solution reference.

## Usage

```Powershell 
Add-XrmSolution [[-XrmClient] <ServiceClient>] [-UniqueName] <String> [-DisplayName] <String> [-PublisherReference] <EntityReference> [[-Version] 
<String>] [[-Description] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$publisher = Get-XrmPublisher -PublisherUniqueName "contoso";
$publisherRef = New-XrmEntityReference -LogicalName "publisher" -Id $publisher.publisherid;
$solution = Add-XrmSolution -UniqueName "contoso_mysolution" -DisplayName "My Solution" -PublisherReference $publisherRef;
``` 


```Powershell 
$solution = Add-XrmSolution -UniqueName "contoso_crm" -DisplayName "Contoso CRM" -PublisherReference $publisherRef -Version "2.0.0.0" -Description "Main CRM solution";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/reference/entities/solution


