# Command : `Import-XrmDocumentTemplate` 

## Description

**Import a local file content into a Dataverse document template.** : Read a file from disk and update the content of an existing Dataverse document template record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Dataverse connection.
TemplateReference|EntityReference|named|false||EntityReference of the Dataverse document template.
TemplateName|String|named|false||Name of the Dataverse document template.
AssociatedEntityLogicalName|String|named|false||Optional logical name of the associated entity. Use it to disambiguate templates with the same name.
FilePath|String|named|true||Full path of the local file to import into the template.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. The updated document template reference.

## Usage

```Powershell 
Import-XrmDocumentTemplate [[-XrmClient] <ServiceClient>] [-TemplateReference] <EntityReference> [-FilePath] <String> [<CommonParameters>]

Import-XrmDocumentTemplate [[-XrmClient] <ServiceClient>] [-TemplateName] <String> [[-AssociatedEntityLogicalName] <String>] [-FilePath] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
Import-XrmDocumentTemplate -TemplateName "Invoice Template" -FilePath "C:\Temp\InvoiceTemplate.docx";

Import-XrmDocumentTemplate -TemplateName "Expense Template" -AssociatedEntityLogicalName "sample_expense" -FilePath "C:\Temp\ExpenseTemplate.docx";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md

