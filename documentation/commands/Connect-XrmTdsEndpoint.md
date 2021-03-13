# Command : `Connect-XrmTdsEndpoint` 

## Description

**Connect to TDS endpoint.** : Specify connection parameters to run SQL commands thru TDS Endpoint.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
UserName|String|1|true||User login
Password|String|2|true||User password
Url|String|3|true||Microsoft Dataverse instance url


## Usage

```Powershell 
Connect-XrmTdsEndpoint [-UserName] <String> [-Password] <String> [-Url] <String> [<CommonParameters>]
``` 


