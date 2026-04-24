# Command : `Export-XrmRecordToWord` 

## Description

**Export a Dataverse record to a Word document using a document template.** : Execute the SetWordTemplate action for a Dataverse record, retrieve the generated document annotation, and save the generated Word file locally.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Dataverse connection.
RecordReference|EntityReference|named|true||EntityReference of the Dataverse record to export.
TemplateReference|EntityReference|named|false||EntityReference of the Dataverse document template.
TemplateName|String|named|false||Name of the Dataverse document template.
AssociatedEntityLogicalName|String|named|false||Optional logical name of the associated entity. Defaults to the record logical name when you export by template name.
OutputPath|String|named|true||Full path where the generated Word document will be written.

## Outputs
System.String. The full path of the exported Word document.

## Usage

```Powershell 
Export-XrmRecordToWord [[-XrmClient] <ServiceClient>] [-RecordReference] <EntityReference> [-TemplateReference] <EntityReference> [-OutputPath] <String> [<CommonParameters>]

Export-XrmRecordToWord [[-XrmClient] <ServiceClient>] [-RecordReference] <EntityReference> [-TemplateName] <String> [[-AssociatedEntityLogicalName] <String>] [-OutputPath] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
Export-XrmRecordToWord -RecordReference $invoice.Reference -TemplateReference $invoiceTemplate.Reference -OutputPath "C:\Temp\Invoice.docx";

Export-XrmRecordToWord -RecordReference $invoice.Reference -TemplateName "Invoice Template" -AssociatedEntityLogicalName "sample_invoice" -OutputPath "C:\Temp\Invoice.docx";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md

