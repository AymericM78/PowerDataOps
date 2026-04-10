# Command : `New-XrmActivityParty` 

## Description

**Create an activity party for Dataverse activity records.** : Build an ActivityParty Entity object to use in email from/to/cc/bcc fields or other activity party lists.
Supports three modes: resolved party (PartyReference only), unresolved party (AddressUsed only),
or resolved party with address override (both).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
PartyReference|EntityReference|1|false||Entity reference of the party (systemuser, contact, account, queue, etc.). Optional if AddressUsed is provided.
AddressUsed|String|2|false||Email address to use for this party. Optional if PartyReference is provided. Can also override the resolved address.

## Outputs
Microsoft.Xrm.Sdk.Entity. An activityparty entity.

## Usage

```Powershell 
New-XrmActivityParty [[-PartyReference] <EntityReference>] [[-AddressUsed] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$from = New-XrmActivityParty -PartyReference $userRef;
$to = New-XrmActivityParty -PartyReference $contactRef -AddressUsed "alt@contoso.com";
$unresolved = New-XrmActivityParty -AddressUsed "external@partner.com";
``` 


