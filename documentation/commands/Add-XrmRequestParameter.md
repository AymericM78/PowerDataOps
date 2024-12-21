# Command : `Add-XrmRequestParameter` 

## Description

**Add parameter to request.** : Add parameter name and value to given request.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Request|OrganizationRequest|1|true||
Name|String|2|true||Parameter name.
Value|Object|3|true||Parameter value.

## Outputs
Microsoft.Xrm.Sdk.OrganizationRequest

## Usage

```Powershell 
Add-XrmRequestParameter [-Request] <OrganizationRequest> [-Name] <String> [-Value] <Object> [<CommonParameters>]
``` 


