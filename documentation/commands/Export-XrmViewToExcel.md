# Command : `Export-XrmViewToExcel` 

## Description

**Export a Dataverse view to an Excel file.** : Execute the ExportToExcel action for a Dataverse saved query and save the generated workbook locally.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Dataverse connection.
ViewReference|EntityReference|named|false||EntityReference of the Dataverse view to export. Supported logical names are `savedquery` and `userquery`.
EntityLogicalName|String|named|false||Logical name of the Dataverse entity used to search the view by name.
ViewName|String|named|false||Display name of the Dataverse view to export.
OutputPath|String|named|true||Full path where the generated Excel workbook will be written.

## Outputs
System.String. The full path of the exported Excel file.

## Usage

```Powershell 
Export-XrmViewToExcel [[-XrmClient] <ServiceClient>] [-ViewReference] <EntityReference> [-OutputPath] <String> [<CommonParameters>]

Export-XrmViewToExcel [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-ViewName] <String> [-OutputPath] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
Export-XrmViewToExcel -ViewReference $view.Reference -OutputPath "C:\Temp\Accounts.xlsx";

Export-XrmViewToExcel -EntityLogicalName "account" -ViewName "Active Accounts" -OutputPath "C:\Temp\Accounts.xlsx";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md

