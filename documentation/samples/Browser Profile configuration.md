# Browser profile configuration with `PowerDataOps` Module

## Context

If you work with multiple tenant, it could be painfull to access your different environnements without using dedicated profile for each tenant.
Then if you have multiple profiles to maintain, you need to apply the same configuration (like extensions), and maintain your favorites.
`PowerDataOps` Module contains a dedicated cmdlet for Chrome / Edge profile configuration => `Export-XrmConnectionToBrowser`.

This cmdlet apply the following operations:

- Provision new browser profile if not exists.
- Create specific shortcut and put it in specified folder.
- Show favorite bar by default for a quick access to favorites.
- Install 'Level Up' and 'Power Pane' extensions
- Add all Power Plateform favorites like O365 Admin, Power Apps Maker, Power Automate, ...
- Retrieve and add all Model-Driven apps links from each environment.

## Overview

This sample show how to :

- Connect to Microsoft Dataverse
- Create browser profile with expected configuration (see above for configuration details)

## Sample code

```Powershell

Import-Module PowerDataOps

# Initialize connection
Connect-XrmUser -AuthType Office365 -UserName "user@contoso.fake" -Password "MyPass123"
# If you have admin rights you can also use
# Connect-XrmAdmin -UserName "user@contoso.fake" -Password "MyPass123"

# Push connection data to XrmToolBox
Export-XrmConnectionToBrowser -ProfileName "Contoso" -IsChrome $true -BrowserShortCutsPath "C:\Users\contoso\Desktop\";

```
