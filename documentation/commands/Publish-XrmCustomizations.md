# Command : `Publish-XrmCustomizations` 

## Description

**Publish customizations.** : Apply unpublished customizations to active layer to promote UI changes.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
ParameterXml|String|2|false||
TimeOutInMinutes|Int32|3|false|5|Specify timeout duration in minute. (Default : 5 min)
Async|Boolean|4|false|True|


## Usage

```Powershell 
Publish-XrmCustomizations [[-XrmClient] <ServiceClient>] [[-ParameterXml] <String>] [[-TimeOutInMinutes] <Int32>] [[-Async] <Boolean>] [<CommonParameters>]
``` 


