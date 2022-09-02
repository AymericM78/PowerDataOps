# Command : `Connect-XrmUser` 

## Description

**Authenticate user to Microsoft Dataverse.** : Prepare Microsoft Dataverse connection with user credentials in order to consume Discovery Service.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
UserName|String|1|false||User login.
Password|String|2|false||User password.
AuthType|String|3|true||User authrentication type. (Office365, AD, Ifd)
=> Warning : Office365 authentication is deprecated!
Region|String|4|false||DataCenter region (France, EMEA, UK, ...) where target instances are located.


## Usage

```Powershell 
Connect-XrmUser [[-UserName] <String>] [[-Password] <String>] [-AuthType] <String> [[-Region] <String>] 
[<CommonParameters>]
``` 


