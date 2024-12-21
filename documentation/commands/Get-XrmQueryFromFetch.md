# Command : `Get-XrmQueryFromFetch` 

## Description

**Retrieve query expression from fetch Xml.** : Convert FetchXml to QueryExpression.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
FetchXml|String|2|true||FetchXML query string.


## Usage

```Powershell 
Get-XrmQueryFromFetch [[-XrmClient] <ServiceClient>] [-FetchXml] <String> [<CommonParameters>]
``` 


