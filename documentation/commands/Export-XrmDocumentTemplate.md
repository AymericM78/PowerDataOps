# Command : `Export-XrmDocumentTemplate` 

## Description

**Export a Dataverse document template to a local file.** : Read the content of a document template record and save it to a file on disk.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
TemplateReference|EntityReference|named|true||EntityReference of the Dataverse document template.
TemplateName|String|named|true||Name of the Dataverse document template.
AssociatedEntityLogicalName|String|named|false||Optional logical name of the entity associated with the document template. Use it to disambiguate templates with the same name.
OutputPath|String|named|true||Full path where the document template content will be written.

## Outputs
System.String. The full path of the exported template file.

## Usage

```Powershell 
Export-XrmDocumentTemplate [-XrmClient <ServiceClient>] -TemplateReference <EntityReference> -OutputPath <String> [<CommonParameters>]

Export-XrmDocumentTemplate [-XrmClient <ServiceClient>] -TemplateName <String> [-AssociatedEntityLogicalName <String>] -OutputPath <String> 
[<CommonParameters>]
``` 

## Examples

```Powershell 
Export-XrmDocumentTemplate -TemplateName "Facture-Template" -OutputPath "C:\Temp\FactureTemplate.docx";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md


