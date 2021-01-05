# Provision XrmToolBox connections with `PowerDataOps` Module

## Context

Maintaining XrmToolBox connections could be painful if you work with mutiple tenants or complexe environment lifecycles.
This sample highlight a simple way to automate this operation and keep accurate connections into your XrmToolBox.

## Overview

This sample show how to :

- Connect to Microsoft Dataverse
- Discover instance and export them as a XrmToolBox connection file

## Sample code

```Powershell

Import-Module PowerDataOps

# Initialize connection
Connect-XrmUser -AuthType Office365 -UserName "user@contoso.fake" -Password "MyPass123"

# Push connection data to XrmToolBox
Export-XrmConnectionToXrmToolBox -Name "Contoso"

```
