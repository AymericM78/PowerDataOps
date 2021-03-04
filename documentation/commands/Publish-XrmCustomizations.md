# Command : `Publish-XrmCustomizations` 

## Description

**Publish customizations.** : Apply unpublished customizations to active layer to promote UI changes.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
ParameterXml|String|2|false||
TimeOutInMinutes|Int32|3|false|10|Specify timeout duration in minute. (Default : 10 min)

## Outputs

## Usage

```Powershell 
Publish-XrmCustomizations [[-XrmClient] <CrmServiceClient>] [[-ParameterXml] <String>] [[-TimeOutInMinutes] <Int32>] [<CommonParameters>]
``` 


