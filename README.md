# PowerDataOps

PowerShell module for Xrm automation (Data Management, administration and DevOps activities)

## Purpose

PowerDataOps is a set of cmdlets dedicated to automation for Microsoft Dataverse implementations :
 - Data operations : CRUD
 - Metadata : work with solution components and layers
 - Administration : user management (get, add roles, ...), audit extract, manage language packs, ...
 - Environment Management : create, backup, restore, copy,  ...
 - DevOps CI/CD : export, import, upgrade solutions

PowerDataOps is designed to simplify dev and ops operations by adding a confortable layer on top of PowerShell Connector (Microsoft.Xrm.Tooling.CrmConnector.PowerShell) and PowerApps admin cmdlet (Microsoft.PowerApps.Administration.PowerShell) provided by Microsoft.

## History

PowerDataOps origin starts in 2014 with a simple wrapper on MSCRM 2013 SDK.
After archeological researchs, I found my first post on this topic
https://docs.microsoft.com/fr-fr/archive/blogs/aymerics_blog/crm-data-management-with-powershell

Then my experience with PowerShell and Microsoft BizApps technologies contribute to enrich this tooling.
Used in several customer productions to bring full automation for dev, packaging, deployment and configuration, this confirm that PowerShell scripting could be robust and flexible to answer recurrent problematics.

## Community contributions

This module is open to community contributions in order to enrich this tooling and helps everyone to bring more automation capabilities to Microsoft Dataverse implementations.

## Well ? And now ?

Check install and usage documentation :)
 - https://github.com/AymericM78/PowerDataOps/blob/main/documentation/install.md
 - https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
