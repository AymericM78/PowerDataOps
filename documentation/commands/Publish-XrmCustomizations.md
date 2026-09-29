# Command : `Publish-XrmCustomizations` 

## Description

**Publish customizations.** : Apply unpublished customizations to active layer to promote UI changes.
PublishAllXmlAsync is monitored until completion and raises an error if the publish job fails. PublishXml (ParameterXml given) and PublishAllXml (Async = false) are synchronous.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ParameterXml|String|2|false||Publish only the components described by this importexportxml (PublishXml message). (Default: publish all)
TimeOutInMinutes|Int32|3|false|5|Specify timeout duration in minute. (Default : 5 min)
Async|Boolean|4|false|True|Publish all with PublishAllXmlAsync and wait for the system job. Ignored when ParameterXml is given. (Default: true)

## Outputs
System.Void.

## Usage

```Powershell 
Publish-XrmCustomizations [[-XrmClient] <ServiceClient>] [[-ParameterXml] <String>] [[-TimeOutInMinutes] <Int32>] [[-Async] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Publish-XrmCustomizations -XrmClient $xrmClient;
``` 


```Powershell 
<entities><entity>account</entity></entities></importexportxml>";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Publish-XrmCustomizations.md


