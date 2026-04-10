# Command : `New-XrmEmail` 

## Description

**Create a new email activity record in Microsoft Dataverse.** : Create an email activity record with from, to, cc, bcc, subject and body. Uses Add-XrmRecord.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
From|Entity[]|2|true||Array of activityparty entities for the sender (use New-XrmActivityParty).
To|Entity[]|3|true||Array of activityparty entities for the recipients (use New-XrmActivityParty).
Cc|Entity[]|4|false||Array of activityparty entities for CC recipients. Optional.
Bcc|Entity[]|5|false||Array of activityparty entities for BCC recipients. Optional.
Subject|String|6|true||Email subject.
Body|String|7|false||Email body (HTML or plain text).
RegardingObjectReference|EntityReference|8|false||Entity reference of the regarding object. Optional.
DirectionCode|Boolean|9|false|True|True = outgoing, False = incoming. Default: true (outgoing).

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created email record.

## Usage

```Powershell 
New-XrmEmail [[-XrmClient] <ServiceClient>] [-From] <Entity[]> [-To] <Entity[]> [[-Cc] <Entity[]>] [[-Bcc] <Entity[]>] [-Subject] <String> [[-Body] <String>] [[-RegardingObjectReference] 
<EntityReference>] [[-DirectionCode] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$from = New-XrmActivityParty -PartyReference $userRef;
$to = New-XrmActivityParty -PartyReference $contactRef;
$ref = New-XrmEmail -From @($from) -To @($to) -Subject "Hello" -Body "<p>World</p>";
``` 


