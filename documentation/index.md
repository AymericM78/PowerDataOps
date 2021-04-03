# PowerDataOps module index

# `Administration` commands

Command|Synopsis
-------|-----------
[Add-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmInstance.md)|Create new Dataverse instance.<br/>Provision new dataverse instance with database.
[Assert-XrmAdminConnected](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Assert-XrmAdminConnected.md)|Check if current user has D365 / Dataverse admin role.<br/>This command is done each time we need to run admin operation. <br/>This mean that we need to proceed to Connect-XrmAdmin before.
[Backup-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Backup-XrmInstance.md)|Backup instance<br/>Add a backup for given instance
[Connect-XrmAdmin](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Connect-XrmAdmin.md)|Use Add-PowerAppsAccount cmdlet signs in the user or application account and saves the sign in information to cache.<br/>Use this command to embed Power Apps Admin cmdlets
[Copy-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Copy-XrmInstance.md)|Copy instance to another.<br/>Copy given source instance to target source instance.
[Get-XrmBackup](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmBackup.md)|Retrieve backup infos<br/>Retrieve a backup from given instance
[Restore-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Restore-XrmInstance.md)|Restore instance at given time.<br/>Restore a backup of given instance to itself or another instance.
[Set-XrmInstanceMode](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmInstanceMode.md)|Enable or disable admin mode on given instance<br/>Administration mode will prevent users to access to instance.
[Watch-XrmOperation](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Watch-XrmOperation.md)|Monitor operation completion.<br/>Poll operation status from given url until its done.
# `Audit` commands

Command|Synopsis
-------|-----------
[Get-XrmAuditHistory](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAuditHistory.md)|Retrieve audit for given record.<br/>Get record audit history for given fields changes
[Get-XrmAuditPartitions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAuditPartitions.md)|Retrieve audit partitions<br/>Get record audit logs with date range and size.
# `BuildTasks` commands

Command|Synopsis
-------|-----------
[Backup-XrmSolutionsBuild](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Backup-XrmSolutionsBuild.md)|Run build action to unpack solutions<br/>This cmdlet is designed to be fully intergrated in Az DevOps pipeline. <br/>This cmdlet export given solutions and then start SolutionPackager extract action to working directory.
[Export-XrmSolutionsBuild](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmSolutionsBuild.md)|Run build action to export solutions.<br/>This cmdlet is designed to be fully intergrated in Az DevOps pipeline. <br/>This cmdlet export given solutions in order to add them to build artifacts.
[Import-XrmSolutionsBuild](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Import-XrmSolutionsBuild.md)|Run build action to import solutions<br/>This cmdlet is designed to be fully intergrated in Az DevOps pipeline. <br/>This cmdlet import given solutions from artifacts.
[Set-XrmSolutionsVersionBuild](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmSolutionsVersionBuild.md)|Run build action to upgrade solutions versions<br/>This cmdlet is designed to be fully intergrated in Az DevOps pipeline. <br/>This cmdlet update solution version number.
# `AzDevOps` commands

Command|Synopsis
-------|-----------
[Add-XrmDevOpsVariableGroup](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmDevOpsVariableGroup.md)|<br/>
[Invoke-XrmDevOpsApi](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmDevOpsApi.md)|<br/>
# `Browser` commands

Command|Synopsis
-------|-----------
[Export-XrmConnectionToBrowser](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmConnectionToBrowser.md)|Configure browser according to Dataverse environnements.<br/>Provision or update Chrome or Edge (based on chromium) profile with all dataverse apps and Power Platform usefull links.
# `Client` commands

Command|Synopsis
-------|-----------
[Add-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmRecord.md)|Create entity record in Microsoft Dataverse.<br/>Add a new row in Microsoft Dataverse table and return created ID (Uniqueidentifier).
[Get-XrmMultipleRecords](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmMultipleRecords.md)|Retrieve multiple records with QueryExpression.<br/>Get rows from Microsoft Dataverse table with specified query (QueryBase). <br/>This command use pagination to pull all records.
[Get-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecord.md)|Search for record with simple query.<br/>Get specific row (Entity record) according to given id, key, or attribute.
[Invoke-XrmBulkRequest](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmBulkRequest.md)|Execute Multiple Organization Request.<br/>Send requests to Microsoft Dataverse for bulk execution.
[Invoke-XrmRequest](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmRequest.md)|Execute Organization Request.<br/>Send request to Microsoft Dataverse for execution.
[Join-XrmRecords](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Join-XrmRecords.md)|Associate records in Dataverse.<br/>Add a link between 1 row (Entity record) and multiple rows in Microsoft Dataverse.
[New-XrmClient](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmClient.md)|Initialize CrmServiceClient instance.<br/>Create a new connection to Microsoft Dataverse with a connectionstring.
[Out-XrmClient](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Out-XrmClient.md)|Initialize CrmserviceClient instance from instance object.<br/>Create a new connection to Microsoft Dataverse from instance object.
[Protect-XrmCommand](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Protect-XrmCommand.md)|Protect command from API Limit issues.<br/>This cmdlet provide a core method for all API calls to Microsoft Dataverse.<br/>The aim is to provide a retry pattern to prevent technical issues as API Limits or network connectivity
[Remove-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmRecord.md)|Remove record from Microsoft Dataverse.<br/>Delete row (entity record) from Microsoft Dataverse table by logicalname + id or by Entity object.
[Set-XrmClientTimeout](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmClientTimeout.md)|Specify CrmserviceClient timeout.<br/>Extend default CrmserviceClient timeout.
[Update-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmRecord.md)|Update entity record in Microsoft Dataverse.<br/>Update row (entity record) from Microsoft Dataverse table.
[Update-XrmRecordFileUpload](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmRecordFileUpload.md)|Upload a file to an entity record's file attribute field in Microsoft Dataverse.<br/>Upload a file to a date row's (entity record's) file field from Microsoft Dataverse table.
[Upsert-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmRecord.md)|Upsert entity record in Dataverse.<br/>Upsert row (entity record) from Microsoft Dataverse table.
[Watch-XrmAsynchOperation](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Watch-XrmAsynchOperation.md)|Monitor async operation completion.<br/>Poll status from asynchoperation id until its done.
# `Connection` commands

Command|Synopsis
-------|-----------
[Connect-XrmUser](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Connect-XrmUser.md)|Authenticate user to Microsoft Dataverse.<br/>Prepare Microsoft Dataverse connection with user credentials in order to consume Discovery Service.
[Export-XrmConnectionToXrmToolBox](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmConnectionToXrmToolBox.md)|Export instances collection to XML file with connection strings to XrmToolBox connection file.<br/>Populate XrmToolbox connections with available instance for given user.
[Get-XrmConnection](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmConnection.md)|Get connections from XrmToolBox.<br/>Browse and retrieve information from XrmToolBox saved connections.
[Import-XrmConnection](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Import-XrmConnection.md)|Import XrmToolBox connection from file.<br/>Populate XrmToolbox connection object from XML file.
[New-XrmConnection](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmConnection.md)|Initialize new object that represent a Dataverse Connection.<br/>
[Out-XrmConnectionString](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Out-XrmConnectionString.md)|Build Connection String from instance object.<br/>Output connection string from given Microsoft Dataverse instance object.
[Out-XrmConnectionStringParameter](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Out-XrmConnectionStringParameter.md)|Extract parameter value from connectionstring.<br/>Output connection string parameter value.
# `Converters` commands

Command|Synopsis
-------|-----------
[ConvertTo-XrmObject](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/ConvertTo-XrmObject.md)|Transform Entity to custom object.<br/>Represent Entity object to custom object.
[ConvertTo-XrmObjects](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/ConvertTo-XrmObjects.md)|Transform Entity Collection to custom object collection.<br/>Represent Entity objects to custom objects array.
# `Entity` commands

Command|Synopsis
-------|-----------
[Get-XrmAttributeValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAttributeValue.md)|Read entity attribute.<br/>Extract entity attribute value from record / table row.
[New-XrmEntity](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntity.md)|Initialize Entity object instance.<br/>Create a new Microsoft Dataverse Entity object.
[Set-XrmAttributeValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmAttributeValue.md)|Set entity attribute value.<br/>Add or update attribute value.
# `Excel` commands

Command|Synopsis
-------|-----------
[Read-XrmExcelSheet](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Read-XrmExcelSheet.md)|Read Excel Sheet.<br/>Get Excel content from given sheet as bi-dimensional array.
[Write-XrmExcelSheet](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Write-XrmExcelSheet.md)|Write Excel Sheet.<br/>Push Microsoft Dataverse rows / entity records to Excel file on a specific sheet.
# `Instances` commands

Command|Synopsis
-------|-----------
[Get-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmInstance.md)|Retrieve instance by name<br/>Get Microsoft Dataverse instance object by its domainname / urlhostname
[Get-XrmInstances](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmInstances.md)|Retrieve instances collection.<br/>Get Microsoft Dataverse instance object collection according to current user rights.
[New-XrmInstance](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmInstance.md)|Initialize new object that represent a Xrm Instance.<br/>
# `LanguagePack` commands

Command|Synopsis
-------|-----------
[Add-XrmLanguagePack](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmLanguagePack.md)|Activate given language.<br/>Install specify language pack to target instance.
[Remove-XrmLanguagePack](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmLanguagePack.md)|Desactivate given language<br/>Uninstall specify language pack from target instance.
# `Metadata` commands

Command|Synopsis
-------|-----------
[Get-XrmAttributesLogicalName](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAttributesLogicalName.md)|Retrieve entities logicalname attribute.<br/>Get list of columns / attribute logical names from given entity / table.
[Get-XrmEntitiesLogicalName](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEntitiesLogicalName.md)|Retrieve entities logicalname<br/>Get list of entity / table logical names.
# `Organization` commands

Command|Synopsis
-------|-----------
[Get-XrmOrganization](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganization.md)|Get Organization object.<br/>Retrieve default organization record from target instance.
[Get-XrmOrganizationClientFeatures](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganizationClientFeatures.md)|Get Organization Client Features.<br/>Retrieve all or specified client features from default organization (see : Get-XrmOrganization)
[Get-XrmOrganizationDbSetting](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganizationDbSetting.md)|Get Organization setting.<br/>Retrieve organization setting (orgdbsetting) from target instance.
[Get-XrmOrganizationFeatures](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganizationFeatures.md)|Get Organization Features<br/>Retrieve all or specified features from default organization (see : Get-XrmOrganization)
[Set-XrmOrganizationClientFeature](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmOrganizationClientFeature.md)|Set Organization Client Feature.<br/>Define specific client feature for default organization (see : Get-XrmOrganization)
[Set-XrmOrganizationDbSetting](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmOrganizationDbSetting.md)|Set Organization setting.<br/>Add or update orgdbsetting value.
[Set-XrmOrganizationFeature](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmOrganizationFeature.md)|Set Organization Feature.<br/>Define specific feature for default organization (see : Get-XrmOrganization)
# `Plugins` commands

Command|Synopsis
-------|-----------
[Get-XrmPluginTraces](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPluginTraces.md)|Retrieve plugin traces.<br/>Get latest plugin trace log from target instance.
[Remove-XrmPluginsFromAssembly](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmPluginsFromAssembly.md)|Remove Plugins Steps and Types From Assembly.<br/>Uninstall all steps and types from plugin assembly.
[Upsert-XrmAssembly](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmAssembly.md)|Create or update plugin / workflow assembly.<br/>Add new or update existing assembly content from local dll file.
# `Query` commands

Command|Synopsis
-------|-----------
[Add-XrmQueryCondition](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryCondition.md)|Add filter to given query expression.<br/>Add new condition criteria to given query expression.
[Add-XrmQueryLink](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryLink.md)|Add link entity to given query expression.<br/>Add new link to given query expression to join to another table / entity.
[Add-XrmQueryLinkCondition](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryLinkCondition.md)|Add filter to given link entity.<br/>Add new condition criteria to given link entity.
[Add-XrmQueryOrder](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryOrder.md)|Add order to query expression.<br/>Set sort order to query expression.
[Get-XrmTotalRecordCount](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmTotalRecordCount.md)|Returns total number of rows in given entity / table.<br/>Returns data on the total number of records for specific entities. (RetrieveTotalRecordCount)
[New-XrmFetchExpression](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmFetchExpression.md)|Return a fetch expression from fetch xml<br/>Initialize new fetch expression object.
[New-XrmQueryExpression](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmQueryExpression.md)|Return QueryExpression object instance.<br/>Initialize new query expression object.
# `Requests` commands

Command|Synopsis
-------|-----------
[Add-XrmRequestParameter](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmRequestParameter.md)|Add parameter to request.<br/>Add parameter name and value to given request.
[New-XrmRequest](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmRequest.md)|Initialize Request object instance.<br/>Get a new Organization Request object instance.
# `Security` commands

Command|Synopsis
-------|-----------
[Add-XrmUserRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmUserRoles.md)|Add security roles to user.<br/>Assign on or multiple roles to given user.
[Get-XrmRolePrivileges](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRolePrivileges.md)|Retrieve security role privileges.<br/>Get role privileges from given role.
[Get-XrmRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRoles.md)|Retrieve security roles.<br/>Get security roles according to different criterias.
[Get-XrmRootBusinessUnit](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRootBusinessUnit.md)|Retrieve root business unit.<br/>Get top  business unit of organization.
[Get-XrmUser](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUser.md)|Retrieve user.<br/>Get system user according to given ID with expected columns.
[Get-XrmUserBusinessUnit](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUserBusinessUnit.md)|Retrieve user business unit.<br/>Get user parent business unit.
[Get-XrmUserRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUserRoles.md)|Retrieve user assigned security roles.<br/>Get security roles associated to given user.
[Get-XrmUsers](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUsers.md)|Retrieve users.<br/>Get all system users from instance.
[Get-XrmUsersRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUsersRoles.md)|Retrieve assigned security roles for all users.<br/>Get all users with associated roles. This could help to determine unused roles or bad configurations.
# `Components` commands

Command|Synopsis
-------|-----------
[Add-XrmSolutionComponent](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmSolutionComponent.md)|Add Solution Component.<br/>Add given component to specified solution.
[Copy-XrmSolutionComponents](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Copy-XrmSolutionComponents.md)|Copy Solution Components.<br/>Add all components from source solution to target one.
[Get-XrmSolutionComponentName](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionComponentName.md)|Get Solution Component name from Id.<br/>Retrieve component name from its number.
[Get-XrmSolutionComponents](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionComponents.md)|Get Solution Components.<br/>Retrieve components from given solution and expected types.
# `Layers` commands

Command|Synopsis
-------|-----------
[Clear-XrmActiveCustomizations](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Clear-XrmActiveCustomizations.md)|Clear active customizations for given solution components.<br/>Performs a cleaning on Active Layer to remove unmanaged customizations for given component types.
[Remove-XrmActiveCustomizations](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmActiveCustomizations.md)|Remove active customizations.<br/>Performs a cleaning on Active Layer to remove unmanaged customizations for given component.
# `Solutions` commands

Command|Synopsis
-------|-----------
[Clear-XrmSolutions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Clear-XrmSolutions.md)|Select solutions to uninstall.<br/>Select solutions (managed or unmanaged) and delete them.
[Export-XrmSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmSolution.md)|Export solution.<br/>Export given solution with given settings.
[Get-XrmBasicSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmBasicSolution.md)|Retrieve basic solution record.<br/>Get basic solution with specified column.
[Get-XrmSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolution.md)|Retrieve solution record.<br/>Get solution by its unique name with expected columns.
[Get-XrmSolutionHistory](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionHistory.md)|Retrieve solutions history.<br/>Get solution operation logs.
[Get-XrmSolutions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutions.md)|Retrieve solutions records.<br/>Get all solutions from instance with expected columns.
[Get-XrmSolutionVersion](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionVersion.md)|Get solution version.<br/>Get version number from given solution.
[Import-XrmSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Import-XrmSolution.md)|Import solution.<br/>Performs solution import to target instance.
[Invoke-XrmSolutionPackager](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmSolutionPackager.md)|Run solution packager tool.<br/>Pack or unpack given solution file with Solution Packager.
[Publish-XrmCustomizations](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Publish-XrmCustomizations.md)|Publish customizations.<br/>Apply unpublished customizations to active layer to promote UI changes.
[Select-XrmSolutions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Select-XrmSolutions.md)|Display solutions selector.<br/>Open gridview view all solutions and select one or many.
[Set-XrmSolutionVersion](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmSolutionVersion.md)|Set solution version.<br/>Update specified solution by its uniquename with given version number.
[Start-XrmSolutionUpgrade](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Start-XrmSolutionUpgrade.md)|Start delete and promote operation for solution.<br/>Replace managed solution by new one after import.
[Watch-XrmCurrentSolutionImport](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Watch-XrmCurrentSolutionImport.md)|Monitor current solution import.<br/>Poll latest solution import status until its done and display progress.
# `SQL` commands

Command|Synopsis
-------|-----------
[Assert-XrmTdsEndpointConnected](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Assert-XrmTdsEndpointConnected.md)|Check if TDS endpoint is enabled.<br/>Assert orgdbsettings EnableTDSEndpoint parameter is true to allow SQL commands thru TDS Endpoint.
[Assert-XrmTdsEndpointEnabled](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Assert-XrmTdsEndpointEnabled.md)|Check if TDS endpoint is enabled.<br/>Assert orgdbsettings EnableTDSEndpoint parameter is true to allow SQL commands thru TDS Endpoint.
[Connect-XrmTdsEndpoint](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Connect-XrmTdsEndpoint.md)|Connect to TDS endpoint.<br/>Specify connection parameters to run SQL commands thru TDS Endpoint.
[Disable-XrmTdsEndpoint](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Disable-XrmTdsEndpoint.md)|Disable TDS endpoint.<br/>Configure orgdbsettings parameter to prevent SQL commands thru TDS Endpoint.
[Enable-XrmTdsEndpoint](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Enable-XrmTdsEndpoint.md)|Enable TDS endpoint.<br/>Configure orgdbsettings parameter to allow SQL commands thru TDS Endpoint.
[Invoke-XrmSqlCommand](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmSqlCommand.md)|Connect to TDS endpoint.<br/>Specify connection parameters to run SQL commands thru TDS Endpoint.
# `Themes` commands

Command|Synopsis
-------|-----------
[Get-XrmTheme](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmTheme.md)|Retrieve theme record.<br/>Get theme by its name with expected columns.
[Get-XrmThemes](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmThemes.md)|Retrieve theme records.<br/>Get themes with expected columns.
[Publish-XrmTheme](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Publish-XrmTheme.md)|Publish theme.<br/>Apply theme to target instance
[Set-XrmThemeColor](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmThemeColor.md)|Change theme color.<br/>Set theme accent color.
# `Tracing` commands

Command|Synopsis
-------|-----------
[Trace-XrmFunction](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Trace-XrmFunction.md)|Output verbose information about function call.<br/>Core module method to trace information and measure calls performance.
[Write-XrmMessageToSlack](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Write-XrmMessageToSlack.md)|Push message to slack<br/>Use Slack webhook to send current message in target channel.
# `Types` commands

Command|Synopsis
-------|-----------
[New-XrmContext](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmContext.md)|Initialize new object that represent a Xrm Context.<br/>Core module cmdlet that create new object to store context information.
[New-XrmDevOpsSettings](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmDevOpsSettings.md)|Initialize new object that represent a DevOps Connection settings.<br/>Core module cmdlet that create new object to store Azure DevOps information.
[New-XrmEntityCollection](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntityCollection.md)|Initialize EntityCollection object instance.<br/>Get new Entity Collection object from entities array.
[New-XrmEntityReference](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntityReference.md)|Initialize EntityReference object instance.<br/>Get new EntityReference object from lookup information.
[New-XrmMoney](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmMoney.md)|Initialize Money object instance.<br/>Get new money object from given decimal value.
[New-XrmOptionSetValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmOptionSetValue.md)|Initialize OptionSetValue object instance.<br/>Get new OptionSetValue object from given int value.
[New-XrmOptionSetValues](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmOptionSetValues.md)|Initialize OptionSetValueCollection object instance.<br/>Get new OptionSetValueCollection object from given int value array.
# `Utilities` commands

Command|Synopsis
-------|-----------
[Add-XrmFolder](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmFolder.md)|Add folder in given path if it doesn't exists.<br/>Create given folder if not exist and return sub folder full path.
[Get-XrmAuthTypes](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAuthTypes.md)|Retrieve authentication type names.<br/>Get available authentication types.
[Get-XrmBase64](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmBase64.md)|Get base 64 from file content.<br/>Read given file and return its content as base64 content.
[Get-XrmRegions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRegions.md)|Retrieve region names.<br/>Get available datacenter regions.
[Set-XrmCredentials](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmCredentials.md)|Initialize PSCredential object.<br/>Create PSCredential from given login and password.
# `Views` commands

Command|Synopsis
-------|-----------
[Get-XrmQueryFromFetch](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmQueryFromFetch.md)|Retrieve query expression from fetch Xml.<br/>Convert FetchXml to QueryExpression.
[Get-XrmRecordsFromView](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecordsFromView.md)|Retrieve records from a view.<br/>Get records according to given view name.
[Get-XrmViews](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmViews.md)|Retrieve savedquery records.<br/>Get all saved query according to entity name and predefined columns.
# `WebResources` commands

Command|Synopsis
-------|-----------
[Sync-XrmWebResources](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Sync-XrmWebResources.md)|Synchronize a webresource folder to Microsoft Dataverse.<br/>Create or update each webresource content based on local directory.
[Upsert-XrmWebResource](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmWebResource.md)|Create or update webresource.<br/>Check if webresource exists or not. If not exists create it and add it to specified solution.<br/>If webresource exists, compare content and update it if different.
# `Workflows` commands

Command|Synopsis
-------|-----------
[Disable-XrmWorkflow](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Disable-XrmWorkflow.md)|Disable a workflow.<br/>Deactivate given workflow.
[Enable-XrmWorkflow](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Enable-XrmWorkflow.md)|Enable a workflow.<br/>Activate given workflow.
[Get-XrmWorkflows](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmWorkflows.md)|Retrieve workflows.<br/>Get workflows with expected columns.
# `_Internals` commands

Command|Synopsis
-------|-----------

