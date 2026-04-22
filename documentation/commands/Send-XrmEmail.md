# Command : `Send-XrmEmail` 

## Description

**Send an email record.** : Send a Dataverse email activity record using the SendEmail SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EmailReference|EntityReference|2|true||Entity reference of the email activity record to send.
IssueSend|Boolean|3|false|True|Whether to issue the send operation. (Default: true)
TrackingToken|String|4|false||Optional tracking token for the email.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The SendEmail response.

## Usage

```Powershell 
Send-XrmEmail [[-XrmClient] <ServiceClient>] [-EmailReference] <EntityReference> [[-IssueSend] <Boolean>] [[-TrackingToken] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$emailRef = New-XrmEntityReference -LogicalName "email" -Id $emailId;
Send-XrmEmail -XrmClient $xrmClient -EmailReference $emailRef;
``` 


