# Command : `Add-XrmRequestParameter` 

## Description

**Add parameter to request.** : Add parameter name and value to given request.
The value is normalized for the SDK: the PowerShell PSObject adapter is removed and a homogeneous Object[] is typed (e.g. @($query) becomes QueryExpression[]). A PSCustomObject or a hashtable cannot be sent to Dataverse and raises an error that names the parameter.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Request|OrganizationRequest|1|true||Organization request to complete.
Name|String|2|true||Parameter name.
Value|Object|3|true||Parameter value. $null is accepted.

## Outputs
Microsoft.Xrm.Sdk.OrganizationRequest. The request, for pipeline chaining.

## Usage

```Powershell 
Add-XrmRequestParameter [-Request] <OrganizationRequest> [-Name] <String> [-Value] <Object> [<CommonParameters>]
``` 

## Examples

```Powershell 
$request = New-XrmRequest -Name "WhoAmI";
$request = $request | Add-XrmRequestParameter -Name "Target" -Value $reference;
``` 


