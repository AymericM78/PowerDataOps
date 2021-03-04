# PowerDataOps module index

# `Administration` commands

Command|Synopsis
-------|-----------
[Add-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmInstance.md)|Create new Dataverse instance.
[Assert-XrmAdminConnected](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Assert-XrmAdminConnected.md)|Check if current user has D365 / Dataverse admin role.
[Backup-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Backup-XrmInstance.md)|Backup instance
[Connect-XrmAdmin](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Connect-XrmAdmin.md)|Use Add-PowerAppsAccount cmdlet signs in the user or application account and saves the sign in information to cache.
[Copy-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Copy-XrmInstance.md)|Copy instance to another.
[Get-XrmBackup](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmBackup.md)|Retrieve backup infos
[Restore-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Restore-XrmInstance.md)|Restore instance at given time.
[Set-XrmInstanceMode](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmInstanceMode.md)|Enable or disable admin mode on given instance
[Watch-XrmOperation](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Watch-XrmOperation.md)|Monitor operation completion.
# `Audit` commands

Command|Synopsis
-------|-----------
[Get-XrmAuditHistory](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAuditHistory.md)|Retrieve audit for given record.
[Get-XrmAuditPartitions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAuditPartitions.md)|Retrieve audit partitions
# `BuildTasks` commands

Command|Synopsis
-------|-----------
[Backup-XrmSolutionsBuild](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Backup-XrmSolutionsBuild.md)|Run build action to unpack solutions
[Export-XrmSolutionsBuild](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmSolutionsBuild.md)|Run build action to export solutions.
[Import-XrmSolutionsBuild](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Import-XrmSolutionsBuild.md)|Run build action to import solutions
[Set-XrmSolutionsVersionBuild](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmSolutionsVersionBuild.md)|Run build action to upgrade solutions versions
# `AzDevOps` commands

Command|Synopsis
-------|-----------
[Add-XrmDevOpsVariableGroup](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmDevOpsVariableGroup.md)|Push Dataverse Instance data to a Az DevOps variable group.
[Invoke-XrmDevOpsApi](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmDevOpsApi.md)|Core function for Az DevOps API consumption.
# `Browser` commands

Command|Synopsis
-------|-----------
[Export-XrmConnectionToBrowser](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmConnectionToBrowser.md)|Configure browser according to Dataverse environnements.
# `Client` commands

Command|Synopsis
-------|-----------
[Add-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmRecord.md)|Create entity record in Microsoft Dataverse.
[Get-XrmMultipleRecords](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmMultipleRecords.md)|Retrieve multiple records with QueryExpression.
[Get-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecord.md)|Search for record with simple query.
[Invoke-XrmBulkRequest](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmBulkRequest.md)|Execute Multiple Organization Request.
[Invoke-XrmRequest](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmRequest.md)|Execute Organization Request.
[Join-XrmRecords](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Join-XrmRecords.md)|Associate records in Dataverse.
[New-XrmClient](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmClient.md)|Initialize CrmServiceClient instance.
[Out-XrmClient](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Out-XrmClient.md)|Initialize CrmserviceClient instance from instance object.
[Protect-XrmCommand](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Protect-XrmCommand.md)|Protect command from API Limit issues.
[Remove-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmRecord.md)|Remove record from Microsoft Dataverse.
[Set-XrmClientTimeout](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmClientTimeout.md)|Specify CrmserviceClient timeout.
[Update-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmRecord.md)|Update entity record in Microsoft Dataverse.
[Upsert-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmRecord.md)|Upsert entity record in Dataverse.
[Watch-XrmAsynchOperation](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Watch-XrmAsynchOperation.md)|Monitor async operation completion.
# `Connection` commands

Command|Synopsis
-------|-----------
[Connect-XrmUser](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Connect-XrmUser.md)|Authenticate user to Microsoft Dataverse.
[Export-XrmConnectionToXrmToolBox](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmConnectionToXrmToolBox.md)|Export instances collection to XML file with connection strings to XrmToolBox connection file.
[New-XrmConnection](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmConnection.md)|Initialize new object that represent a Dataverse Connection.
[Out-XrmConnectionString](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Out-XrmConnectionString.md)|Build Connection String from instance object.
[Out-XrmConnectionStringParameter](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Out-XrmConnectionStringParameter.md)|Extract parameter value from connectionstring.
# `Converters` commands

Command|Synopsis
-------|-----------
[ConvertTo-XrmObject](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/ConvertTo-XrmObject.md)|Transform Entity to custom object.
[ConvertTo-XrmObjects](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/ConvertTo-XrmObjects.md)|Transform Entity Collection to custom object collection.
# `Entity` commands

Command|Synopsis
-------|-----------
[Get-XrmAttributeValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAttributeValue.md)|Read entity attribute.
[New-XrmEntity](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntity.md)|Initialize Entity object instance.
[Set-XrmAttributeValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmAttributeValue.md)|Set entity attribute value.
# `Excel` commands

Command|Synopsis
-------|-----------
[Read-XrmExcelSheet](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Read-XrmExcelSheet.md)|Read Excel Sheet.
[Write-XrmExcelSheet](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Write-XrmExcelSheet.md)|Write Excel Sheet.
# `Instances` commands

Command|Synopsis
-------|-----------
[Get-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmInstance.md)|Retrieve instance by name
[Get-XrmInstances](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmInstances.md)|Retrieve instances collection.
[New-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmInstance.md)|Initialize new object that represent a Xrm Instance.
# `LanguagePack` commands

Command|Synopsis
-------|-----------
[Add-XrmLanguagePack](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmLanguagePack.md)|Activate given language.
[Remove-XrmLanguagePack](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmLanguagePack.md)|Desactivate given language
# `Metadata` commands

Command|Synopsis
-------|-----------
[Get-XrmAttributesLogicalName](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAttributesLogicalName.md)|Retrieve entities logicalname attribute.
[Get-XrmEntitiesLogicalName](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEntitiesLogicalName.md)|Retrieve entities logicalname
# `Organization` commands

Command|Synopsis
-------|-----------
[Get-XrmOrganization](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganization.md)|Get Organization object.
[Get-XrmOrganizationClientFeatures](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganizationClientFeatures.md)|Get Organization Client Features.
[Get-XrmOrganizationFeatures](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganizationFeatures.md)|Get Organization Features
[Set-XrmOrganizationClientFeature](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmOrganizationClientFeature.md)|Set Organization Client Feature.
[Set-XrmOrganizationFeature](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmOrganizationFeature.md)|Set Organization Feature.
# `Plugins` commands

Command|Synopsis
-------|-----------
[Get-XrmPluginTraces](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPluginTraces.md)|Retrieve plugin traces.
[Remove-XrmPluginsFromAssembly](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmPluginsFromAssembly.md)|Remove Plugins Steps and Types From Assembly.
[Upsert-XrmAssembly](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmAssembly.md)|Create or update plugin / workflow assembly.
# `Query` commands

Command|Synopsis
-------|-----------
[Add-XrmQueryCondition](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryCondition.md)|Add filter to given query expression.
[Add-XrmQueryLink](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryLink.md)|Add link entity to given query expression.
[Add-XrmQueryLinkCondition](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryLinkCondition.md)|Add filter to given link entity.
[Add-XrmQueryOrder](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryOrder.md)|Add order to query expression.
[Get-XrmTotalRecordCount](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmTotalRecordCount.md)|Returns total number of rows in given entity / table.
[New-XrmFetchExpression](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmFetchExpression.md)|Return a fetch expression from fetch xml
[New-XrmQueryExpression](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmQueryExpression.md)|Return QueryExpression object instance.
# `Requests` commands

Command|Synopsis
-------|-----------
[Add-XrmRequestParameter](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmRequestParameter.md)|Add parameter to request.
[New-XrmRequest](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmRequest.md)|Initialize Request object instance.
# `Security` commands

Command|Synopsis
-------|-----------
[Add-XrmUserRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmUserRoles.md)|Add security roles to user.
[Get-XrmRolePrivileges](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRolePrivileges.md)|Retrieve security role privileges.
[Get-XrmRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRoles.md)|Retrieve security roles.
[Get-XrmRootBusinessUnit](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRootBusinessUnit.md)|Retrieve root business unit.
[Get-XrmUser](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUser.md)|Retrieve user.
[Get-XrmUserBusinessUnit](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUserBusinessUnit.md)|Retrieve user business unit.
[Get-XrmUserRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUserRoles.md)|Retrieve user assigned security roles.
[Get-XrmUsers](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUsers.md)|Retrieve users.
[Get-XrmUsersRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUsersRoles.md)|Retrieve assigned security roles for all users.
# `Components` commands

Command|Synopsis
-------|-----------
[Add-XrmSolutionComponent](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmSolutionComponent.md)|Add Solution Component.
[Copy-XrmSolutionComponents](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Copy-XrmSolutionComponents.md)|Copy Solution Components.
[Get-XrmSolutionComponentName](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionComponentName.md)|Get Solution Component name from Id.
[Get-XrmSolutionComponents](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionComponents.md)|Get Solution Components.
# `Layers` commands

Command|Synopsis
-------|-----------
[Clear-XrmActiveCustomizations](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Clear-XrmActiveCustomizations.md)|Clear active customizations for given solution components.
[Remove-XrmActiveCustomizations](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmActiveCustomizations.md)|Remove active customizations.
# `Solutions` commands

Command|Synopsis
-------|-----------
[Clear-XrmSolutions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Clear-XrmSolutions.md)|Select solutions to uninstall.
[Export-XrmSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmSolution.md)|Export solution.
[Get-NonCustomizableEntities](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-NonCustomizableEntities.md)|Provide entity logical names that could not be customize (standard system entities (customization, relationship, non customizable tables))
[Get-XrmBasicSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmBasicSolution.md)|Retrieve basic solution record.
[Get-XrmSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolution.md)|Retrieve solution record.
[Get-XrmSolutionHistory](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionHistory.md)|Retrieve solutions history.
[Get-XrmSolutions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutions.md)|Retrieve solutions records.
[Get-XrmSolutionVersion](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionVersion.md)|Get solution version.
[Import-XrmSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Import-XrmSolution.md)|Import solution.
[Invoke-XrmSolutionPackager](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmSolutionPackager.md)|Run solution packager tool.
[Publish-XrmCustomizations](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Publish-XrmCustomizations.md)|Publish customizations.
[Select-XrmSolutions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Select-XrmSolutions.md)|Display solutions selector.
[Set-XrmSolutionVersion](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmSolutionVersion.md)|Set solution version.
[Start-XrmSolutionUpgrade](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Start-XrmSolutionUpgrade.md)|Start delete and promote operation for solution.
[Watch-XrmCurrentSolutionImport](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Watch-XrmCurrentSolutionImport.md)|Monitor current solution import.
# `Tracing` commands

Command|Synopsis
-------|-----------
[Trace-XrmFunction](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Trace-XrmFunction.md)|Output verbose information about function call.
[Write-HostAndLog](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Write-HostAndLog.md)|Display message and output to file.
[Write-XrmMessageToSlack](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Write-XrmMessageToSlack.md)|Push message to slack
# `Types` commands

Command|Synopsis
-------|-----------
[New-XrmContext](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmContext.md)|Initialize new object that represent a Xrm Context.
[New-XrmDevOpsSettings](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmDevOpsSettings.md)|Initialize new object that represent a DevOps Connection settings.
[New-XrmEntityCollection](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntityCollection.md)|Initialize EntityCollection object instance.
[New-XrmEntityReference](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntityReference.md)|Initialize EntityReference object instance.
[New-XrmMoney](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmMoney.md)|Initialize Money object instance.
[New-XrmOptionSetValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmOptionSetValue.md)|Initialize OptionSetValue object instance.
[New-XrmOptionSetValues](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmOptionSetValues.md)|Initialize OptionSetValueCollection object instance.
# `Utilities` commands

Command|Synopsis
-------|-----------
[Add-XrmFolder](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmFolder.md)|Add folder in given path if it doesn't exists.
[ForEach-ObjectWithProgress](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/ForEach-ObjectWithProgress.md)|Process each object and report progress
[Get-XrmAuthTypes](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAuthTypes.md)|Retrieve authentication type names.
[Get-XrmBase64](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmBase64.md)|Get base 64 from file content.
[Get-XrmRegions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRegions.md)|Retrieve region names.
[Set-XrmCredentials](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmCredentials.md)|Initialize PSCredential object.
# `Views` commands

Command|Synopsis
-------|-----------
[Get-XrmQueryFromFetch](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmQueryFromFetch.md)|Retrieve query expression from fetch Xml.
[Get-XrmRecordsFromView](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecordsFromView.md)|Retrieve records from a view.
[Get-XrmViews](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmViews.md)|Retrieve savedquery records.
# `WebResources` commands

Command|Synopsis
-------|-----------
[Sync-XrmWebResources](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Sync-XrmWebResources.md)|Synchronize a webresource folder to Microsoft Dataverse.
[Upsert-XrmWebResource](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmWebResource.md)|Create or update webresource.

