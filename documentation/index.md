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
# `AppModule` commands

Command|Synopsis
-------|-----------
[Add-XrmAppComponent](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmAppComponent.md)|Add components to a model-driven app.<br/>Add one or more components (tables, forms, views, dashboards, BPF, sitemap, etc.) to an existing model-driven app using the AddAppComponents SDK action.
[Add-XrmAppModule](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmAppModule.md)|Create a new model-driven app in Microsoft Dataverse.<br/>Create a new appmodule record (model-driven app) with the specified name and properties.
[Add-XrmSiteMap](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmSiteMap.md)|Create a new sitemap in Microsoft Dataverse.<br/>Create a new sitemap record with the given navigation XML. Sitemaps define the navigation structure of model-driven apps.
[Get-XrmAppComponents](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAppComponents.md)|Retrieve components of a model-driven app.<br/>Get all components included in a published model-driven app using the RetrieveAppComponents SDK function.
[Get-XrmAppModules](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAppModules.md)|Retrieve model-driven app records from Microsoft Dataverse.<br/>Get appmodule records (model-driven apps) with optional name filter.
[Get-XrmSiteMaps](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSiteMaps.md)|Retrieve sitemap records from Microsoft Dataverse.<br/>Get sitemap records with optional name filter. Sitemaps define the navigation structure of model-driven apps.
[Remove-XrmAppComponent](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmAppComponent.md)|Remove components from a model-driven app.<br/>Remove one or more components from an existing model-driven app using the RemoveAppComponents SDK action.
[Remove-XrmAppModule](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmAppModule.md)|Delete a model-driven app from Microsoft Dataverse.<br/>Remove an appmodule record (model-driven app).
[Set-XrmAppModule](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmAppModule.md)|Update a model-driven app in Microsoft Dataverse.<br/>Update appmodule record properties (name, description, icon).
[Set-XrmSiteMap](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmSiteMap.md)|Update a sitemap in Microsoft Dataverse.<br/>Update the SiteMapXml attribute of an existing sitemap record. The sitemap defines the navigation structure of a model-driven app.
[Test-XrmAppModule](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmAppModule.md)|Validate a model-driven app.<br/>Check a model-driven app for missing dependencies using the ValidateApp SDK function.
# `Attributes` commands

Command|Synopsis
-------|-----------
[Get-XrmAttributeValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAttributeValue.md)|Read entity attribute.<br/>Extract entity attribute value from record / table row.
[Set-XrmAttributeValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmAttributeValue.md)|Set entity attribute value.<br/>Add or update attribute value.
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
# `Browser` commands

Command|Synopsis
-------|-----------
[Export-XrmConnectionToBrowser](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmConnectionToBrowser.md)|Configure browser according to Dataverse environnements.<br/>Provision or update Chrome or Edge (based on chromium) profile with all dataverse apps and Power Platform usefull links.
# `Client` commands

Command|Synopsis
-------|-----------
[Add-XrmBulkDelete](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmBulkDelete.md)|Create a bulk delete job.<br/>Submit a BulkDeleteRequest to asynchronously delete records matching a given query expression.
[Add-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmRecord.md)|Create entity record in Microsoft Dataverse.<br/>Add a new row in Microsoft Dataverse table and return created ID (Uniqueidentifier).
[Get-XrmDuplicateRules](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmDuplicateRules.md)|Retrieve duplicate detection rules from Microsoft Dataverse.<br/>Get duplicaterule records with optional entity filter.
[Get-XrmMultipleRecords](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmMultipleRecords.md)|Retrieve multiple records with QueryExpression.<br/>Get rows from Microsoft Dataverse table with specified query (QueryBase). <br/>This command use pagination to pull all records.
[Get-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecord.md)|Search for record with simple query.<br/>Get specific row (Entity record) according to given id, key, or attribute.
[Get-XrmRecordFileDownload](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecordFileDownload.md)|Download a file from a file or image column.<br/>Download a file stored in a Dataverse file/image column using the InitializeFileBlocksDownload and DownloadBlock SDK messages.
[Invoke-XrmBulkRequest](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmBulkRequest.md)|Execute Multiple Organization Request.<br/>Send requests to Microsoft Dataverse for bulk execution.
[Invoke-XrmBulkRequests](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmBulkRequests.md)|Split and Execute Multiple Organization Requests.<br/>Send requests to Microsoft Dataverse for bulk execution.
[Invoke-XrmRequest](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmRequest.md)|Execute Organization Request.<br/>Send request to Microsoft Dataverse for execution.
[Join-XrmRecords](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Join-XrmRecords.md)|Associate records in Dataverse.<br/>Add a link between 1 row (Entity record) and multiple rows in Microsoft Dataverse.
[Merge-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Merge-XrmRecord.md)|Merge two records in Microsoft Dataverse.<br/>Merge a subordinate record into a target record using the Merge SDK message.<br/>The subordinate record is deactivated after the merge.
[New-XrmClient](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmClient.md)|Initialize CrmServiceClient instance.<br/>Create a new connection to Microsoft Dataverse with a connectionstring.
[Out-XrmClient](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Out-XrmClient.md)|Initialize CrmserviceClient instance from instance object.<br/>Create a new connection to Microsoft Dataverse from instance object.
[Protect-XrmCommand](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Protect-XrmCommand.md)|Protect command from API Limit issues.<br/>This cmdlet provide a core method for all API calls to Microsoft Dataverse.<br/>The aim is to provide a retry pattern to prevent technical issues as API Limits or network connectivity
[Publish-XrmDuplicateRule](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Publish-XrmDuplicateRule.md)|Publish a duplicate detection rule.<br/>Publish (activate) a duplicate detection rule using the PublishDuplicateRule SDK action.
[Remove-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmRecord.md)|Remove record from Microsoft Dataverse.<br/>Delete row (entity record) from Microsoft Dataverse table by logicalname + id or by Entity object.
[Set-XrmClientTimeout](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmClientTimeout.md)|Specify CrmserviceClient timeout.<br/>Extend default CrmserviceClient timeout.
[Set-XrmRecordState](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmRecordState.md)|Set the state and status of a record.<br/>Update the statecode and statuscode of a Dataverse record using Update-XrmRecord.
[Split-XrmRecords](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Split-XrmRecords.md)|Disassociate records in Dataverse.<br/>Remove a link between 1 row (Entity record) and multiple rows in Microsoft Dataverse.
[Sync-XrmRecords](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Sync-XrmRecords.md)|Synchronize records between two Dataverse instances.<br/>Reads records from a source instance, transforms attributes according to sync options,<br/>then upserts records in a target instance. Supports optional two-pass dependency sync.
[Update-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmRecord.md)|Update entity record in Microsoft Dataverse.<br/>Update row (entity record) from Microsoft Dataverse table.
[Update-XrmRecordFileUpload](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmRecordFileUpload.md)|Upload a file to an entity record's file attribute field in Microsoft Dataverse.<br/>Upload a file to a date row's (entity record's) file field from Microsoft Dataverse table.
[Update-XrmRollupField](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmRollupField.md)|Recalculate a rollup field value.<br/>Force recalculation of a rollup field for a specific record using the CalculateRollupField SDK function.
[Upsert-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmRecord.md)|Upsert entity record in Dataverse.<br/>Upsert row (entity record) from Microsoft Dataverse table.
[Watch-XrmAsynchOperation](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Watch-XrmAsynchOperation.md)|Monitor async operation completion.<br/>Poll status from asynchoperation id until its done.
# `Connection` commands

Command|Synopsis
-------|-----------
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
[ConvertTo-XrmType](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/ConvertTo-XrmType.md)|Convert a value to the appropriate Dataverse SDK type.<br/>Transform a raw value (string, number) to a typed Dataverse attribute value based on the specified type<br/>(int, decimal, datetime, money, bool, guid, optionset, optionsetvalues, entityreference, string).
# `Customization` commands

Command|Synopsis
-------|-----------
[Add-XrmChart](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmChart.md)|Create a new chart in Microsoft Dataverse.<br/>Create a new savedqueryvisualization record (system chart).
[Add-XrmCommand](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmCommand.md)|Create a new command bar button in Microsoft Dataverse.<br/>Create a new appaction record (command bar button).
[Add-XrmDashboard](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmDashboard.md)|Create a new dashboard in Microsoft Dataverse.<br/>Create a new systemform record of type dashboard (type = 0). Delegates to Add-XrmForm.
[Add-XrmForm](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmForm.md)|Create a new form in Microsoft Dataverse.<br/>Create a new systemform record.
[Add-XrmFormControl](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmFormControl.md)|Add a PCF custom control to a form field.<br/>Add a Power Apps Component Framework (PCF) custom control binding onto a field in a model-driven app form<br/>by modifying the FormXML of the systemform record.
[Add-XrmView](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmView.md)|Create a new view in Microsoft Dataverse.<br/>Create a new savedquery record (system view).
[Copy-XrmForm](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Copy-XrmForm.md)|Copy an existing form in Microsoft Dataverse.<br/>Clone a systemform record using the CopySystemForm SDK action. Creates an exact copy of the source form with a new name.
[Export-XrmRibbon](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmRibbon.md)|Export the ribbon customization XML for a table.<br/>Export the RibbonDiffXml for a specific table by creating a temporary solution containing the table,<br/>exporting the solution, extracting the customizations.xml, and parsing the RibbonDiffXml node.<br/>This allows reading and modifying classic ribbon customizations programmatically.
[Get-XrmCharts](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmCharts.md)|Retrieve chart records from Microsoft Dataverse.<br/>Get savedqueryvisualization records (system charts) filtered by entity logical name.
[Get-XrmCommands](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmCommands.md)|Retrieve command records from Microsoft Dataverse.<br/>Get appaction records (command bar buttons) optionally filtered by entity context.
[Get-XrmDashboards](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmDashboards.md)|Retrieve dashboard records from Microsoft Dataverse.<br/>Get systemform records filtered to dashboards (type = 0). Delegates to Get-XrmForms.
[Get-XrmFormControls](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmFormControls.md)|List PCF custom controls configured on a form.<br/>Parse the FormXML of a systemform record and return all custom control bindings (PCF controls).
[Get-XrmForms](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmForms.md)|Retrieve form records from Microsoft Dataverse.<br/>Get systemform records (forms) filtered by entity logical name and optionally by form type.
[Import-XrmRibbon](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Import-XrmRibbon.md)|Import ribbon customization XML for a table.<br/>Import a modified RibbonDiffXml for a specific table by creating a temporary solution containing the table,<br/>exporting the solution, replacing the RibbonDiffXml node in customizations.xml, re-zipping, and importing.<br/>This allows modifying classic ribbon customizations (commands, display rules, enable rules) programmatically.
[Remove-XrmChart](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmChart.md)|Delete a chart from Microsoft Dataverse.<br/>Delete a savedqueryvisualization record (system chart).
[Remove-XrmCommand](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmCommand.md)|Delete a command bar button from Microsoft Dataverse.<br/>Delete an appaction record (command bar button).
[Remove-XrmDashboard](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmDashboard.md)|Delete a dashboard from Microsoft Dataverse.<br/>Delete a systemform record (dashboard). Delegates to Remove-XrmForm.
[Remove-XrmForm](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmForm.md)|Delete a form from Microsoft Dataverse.<br/>Delete a systemform record.
[Remove-XrmFormControl](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmFormControl.md)|Remove a PCF custom control from a form field.<br/>Remove a Power Apps Component Framework (PCF) custom control binding from a field in a model-driven app form<br/>by modifying the FormXML of the systemform record.
[Remove-XrmView](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmView.md)|Delete a view from Microsoft Dataverse.<br/>Delete a savedquery record (system view).
[Set-XrmChart](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmChart.md)|Update a chart in Microsoft Dataverse.<br/>Update an existing savedqueryvisualization record (system chart).
[Set-XrmCommand](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmCommand.md)|Update a command bar button in Microsoft Dataverse.<br/>Update an existing appaction record (command bar button).
[Set-XrmDashboard](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmDashboard.md)|Update a dashboard in Microsoft Dataverse.<br/>Update an existing systemform record (dashboard). Delegates to Set-XrmForm.
[Set-XrmForm](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmForm.md)|Update a form in Microsoft Dataverse.<br/>Update an existing systemform record.
[Set-XrmView](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmView.md)|Update a view in Microsoft Dataverse.<br/>Update an existing savedquery record (system view).
# `Email` commands

Command|Synopsis
-------|-----------
[New-XrmActivityParty](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmActivityParty.md)|Create an activity party for Dataverse activity records.<br/>Build an ActivityParty Entity object to use in email from/to/cc/bcc fields or other activity party lists.<br/>Supports three modes: resolved party (PartyReference only), unresolved party (AddressUsed only),<br/>or resolved party with address override (both).
[New-XrmEmail](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEmail.md)|Create a new email activity record in Microsoft Dataverse.<br/>Create an email activity record with from, to, cc, bcc, subject and body. Uses Add-XrmRecord.
[Send-XrmEmail](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Send-XrmEmail.md)|Send an email record.<br/>Send a Dataverse email activity record using the SendEmail SDK message.
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
[Add-XrmAlternateKey](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmAlternateKey.md)|Create an alternate key on a Microsoft Dataverse table.<br/>Add a new entity key using CreateEntityKeyRequest.
[Add-XrmColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmColumn.md)|Create a new column in Microsoft Dataverse.<br/>Add a new attribute / column to a table using CreateAttributeRequest.<br/>Use typed constructors such as New-XrmStringColumn, New-XrmBooleanColumn,<br/>New-XrmIntegerColumn, New-XrmDecimalColumn, New-XrmDoubleColumn,<br/>New-XrmMoneyColumn, New-XrmDateColumn, New-XrmChoiceColumn,<br/>New-XrmMultiChoiceColumn, New-XrmFileColumn, New-XrmImageColumn,<br/>New-XrmMemoColumn, and New-XrmAutoNumberColumn to build the<br/>AttributeMetadata object.<br/><br/>Relationship-based lookups require specialized SDK messages and should use<br/>Add-XrmOneToManyRelationship or Add-XrmPolymorphicLookup instead of<br/>Add-XrmColumn.
[Add-XrmGlobalOptionSet](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmGlobalOptionSet.md)|Create a global option set in Microsoft Dataverse.<br/>Create a new global option set using CreateOptionSetRequest.
[Add-XrmManyToManyRelationship](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmManyToManyRelationship.md)|Create a many-to-many relationship in Microsoft Dataverse.<br/>Create an N:N relationship using CreateManyToManyRequest.
[Add-XrmOneToManyRelationship](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmOneToManyRelationship.md)|Create a one-to-many relationship in Microsoft Dataverse.<br/>Create a 1:N relationship using CreateOneToManyRequest.
[Add-XrmOptionSetValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmOptionSetValue.md)|Insert a new option value in an option set.<br/>Insert a new option value in a global or local option set using the InsertOptionValue SDK message.
[Add-XrmPolymorphicLookup](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmPolymorphicLookup.md)|Create a polymorphic lookup attribute in Microsoft Dataverse.<br/>Create a polymorphic lookup column that can reference multiple table types using the CreatePolymorphicLookupAttribute SDK message.
[Add-XrmStatusValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmStatusValue.md)|Insert a new status value (status reason) for a table.<br/>Add a new status reason value to a Status attribute using the InsertStatusValue SDK message.
[Add-XrmTable](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmTable.md)|Create a new table in Microsoft Dataverse.<br/>Create a new entity / table using CreateEntityRequest.
[Get-XrmAllEntityMetadata](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAllEntityMetadata.md)|Retrieve all entity metadata<br/>Get list of entity / table metadata.
[Get-XrmAlternateKey](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAlternateKey.md)|Retrieve alternate key metadata from Microsoft Dataverse.<br/>Get entity key metadata using RetrieveEntityKeyRequest.
[Get-XrmAttributesLogicalName](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAttributesLogicalName.md)|Retrieve entities logicalname attribute.<br/>Get list of columns / attribute logical names from given entity / table.
[Get-XrmAutoNumberSeed](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAutoNumberSeed.md)|Get the current auto-number seed for a column.<br/>Retrieve the current auto-number seed value for an auto-number column using the GetAutoNumberSeed SDK message.
[Get-XrmColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmColumn.md)|Retrieve column metadata from Microsoft Dataverse.<br/>Get attribute / column metadata using RetrieveAttributeRequest.
[Get-XrmEntitiesLogicalName](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEntitiesLogicalName.md)|Retrieve entities logicalname<br/>Get list of entity / table logical names.
[Get-XrmEntityMetadata](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEntityMetadata.md)|Retrieve entity metadata<br/>Get entity / table metadata.
[Get-XrmGlobalOptionSet](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmGlobalOptionSet.md)|Retrieve a global option set from Microsoft Dataverse.<br/>Get global option set metadata using RetrieveOptionSetRequest.
[Get-XrmRelationship](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRelationship.md)|Retrieve relationship metadata from Microsoft Dataverse.<br/>Get relationship metadata using RetrieveRelationshipRequest.
[New-XrmAutoNumberColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmAutoNumberColumn.md)|Build an auto-number StringAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata object<br/>with AutoNumberFormat, ready for Add-XrmColumn.
[New-XrmBooleanColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmBooleanColumn.md)|Build a BooleanAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.BooleanAttributeMetadata object<br/>that can be passed to Add-XrmColumn.
[New-XrmChoiceColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmChoiceColumn.md)|Build a PicklistAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata object<br/>referencing a global option set or defining local options, ready for Add-XrmColumn.
[New-XrmDateColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmDateColumn.md)|Build a DateTimeAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.DateTimeAttributeMetadata object<br/>that can be passed to Add-XrmColumn.
[New-XrmDecimalColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmDecimalColumn.md)|Build a DecimalAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.DecimalAttributeMetadata object<br/>that can be passed to Add-XrmColumn.
[New-XrmDoubleColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmDoubleColumn.md)|Build a DoubleAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.DoubleAttributeMetadata object<br/>that can be passed to Add-XrmColumn.
[New-XrmFileColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmFileColumn.md)|Build a FileAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.FileAttributeMetadata object<br/>that can be passed to Add-XrmColumn.
[New-XrmImageColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmImageColumn.md)|Build an ImageAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.ImageAttributeMetadata object<br/>that can be passed to Add-XrmColumn.
[New-XrmIntegerColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmIntegerColumn.md)|Build an IntegerAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.IntegerAttributeMetadata object<br/>that can be passed to Add-XrmColumn.
[New-XrmLookupColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmLookupColumn.md)|Build a LookupAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata object<br/>for relationship-based creation requests such as Add-XrmOneToManyRelationship<br/>or Add-XrmPolymorphicLookup. This constructor does not create the lookup<br/>through Add-XrmColumn because Dataverse requires a relationship creation<br/>request for lookup attributes.
[New-XrmMemoColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmMemoColumn.md)|Build a MemoAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.MemoAttributeMetadata object<br/>that can be passed to Add-XrmColumn.
[New-XrmMoneyColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmMoneyColumn.md)|Build a MoneyAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.MoneyAttributeMetadata object<br/>that can be passed to Add-XrmColumn.
[New-XrmMultiChoiceColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmMultiChoiceColumn.md)|Build a MultiSelectPicklistAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.MultiSelectPicklistAttributeMetadata object<br/>referencing a global option set or defining local options, ready for Add-XrmColumn.
[New-XrmStringColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmStringColumn.md)|Build a StringAttributeMetadata for a Dataverse column.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata object<br/>that can be passed to Add-XrmColumn.
[Remove-XrmAlternateKey](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmAlternateKey.md)|Delete an alternate key from a Microsoft Dataverse table.<br/>Delete an entity key using DeleteEntityKeyRequest.
[Remove-XrmColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmColumn.md)|Delete a column from Microsoft Dataverse.<br/>Delete an attribute / column from a table using DeleteAttributeRequest.
[Remove-XrmGlobalOptionSet](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmGlobalOptionSet.md)|Delete a global option set from Microsoft Dataverse.<br/>Delete a global option set using DeleteOptionSetRequest.
[Remove-XrmOptionSetValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmOptionSetValue.md)|Delete an option value from an option set.<br/>Delete an option value from a global or local option set using the DeleteOptionValue SDK message.
[Remove-XrmRelationship](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmRelationship.md)|Delete a relationship from Microsoft Dataverse.<br/>Delete a relationship using DeleteRelationshipRequest.
[Remove-XrmTable](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmTable.md)|Delete a table from Microsoft Dataverse.<br/>Delete an entity / table using DeleteEntityRequest.
[Set-XrmAutoNumberSeed](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmAutoNumberSeed.md)|Set the auto-number seed for a column.<br/>Set the next auto-number value for an auto-number column using the SetAutoNumberSeed SDK message.
[Set-XrmColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmColumn.md)|Update a column in Microsoft Dataverse.<br/>Update an existing attribute / column metadata using UpdateAttributeRequest.
[Set-XrmGlobalOptionSet](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmGlobalOptionSet.md)|Update a global option set in Microsoft Dataverse.<br/>Update an existing global option set using UpdateOptionSetRequest.
[Set-XrmGlobalOptionSetOptions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmGlobalOptionSetOptions.md)|Synchronize the options of a global option set.<br/>Update the list of options of an existing global option set from a typed OptionMetadata list.<br/>Existing values are updated with Set-XrmOptionSetValue, missing values are created with<br/>Add-XrmOptionSetValue, and extra values can optionally be removed.
[Set-XrmLocalizedLabel](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmLocalizedLabel.md)|Set localized labels on a Dataverse metadata component.<br/>Update localized labels on a metadata attribute, entity, option value, or relationship using the SetLocLabels SDK message.
[Set-XrmLocalOptionSet](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmLocalOptionSet.md)|Synchronize the local options of a choice column.<br/>Update the list of options of an existing local choice or multichoice column from a typed<br/>OptionMetadata list. Existing values are updated with Set-XrmOptionSetValue, missing values<br/>are created with Add-XrmOptionSetValue, and extra values can optionally be removed.
[Set-XrmOptionSetOrder](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmOptionSetOrder.md)|Set the display order of option set values.<br/>Reorder the values of a global or local option set using the OrderOption SDK message.
[Set-XrmOptionSetValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmOptionSetValue.md)|Update an option value in an option set.<br/>Update an existing option value in a global or local option set using the UpdateOptionValue SDK message.
[Set-XrmStateValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmStateValue.md)|Update a state value in a StateAttributeMetadata attribute.<br/>Update the label and description of a statecode option using the UpdateStateValue SDK message.
[Set-XrmTable](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmTable.md)|Update a table in Microsoft Dataverse.<br/>Update an existing entity / table metadata using UpdateEntityRequest.
[Test-XrmColumn](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmColumn.md)|Verify whether a Dataverse column exists.<br/>Return $true when a column exists on the specified table. Optionally enforce a specific<br/>metadata type such as [Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata].
[Test-XrmGlobalOptionSet](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmGlobalOptionSet.md)|Verify whether a Dataverse global option set exists.<br/>Return $true when a global option set exists for the specified name.
[Test-XrmTable](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmTable.md)|Verify whether a Dataverse table exists.<br/>Return $true when a table/entity metadata record exists for the specified logical name.
[Update-XrmOptionSetColors](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmOptionSetColors.md)|Update option set value colors.<br/>Update the color property of option set values for a given picklist attribute using the UpdateOptionValue SDK message.
# `Organization` commands

Command|Synopsis
-------|-----------
[Get-XrmEnvironmentVariableValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEnvironmentVariableValue.md)|Retrieve environment variable value.<br/>Get the current value of a Dataverse environment variable by its schema name.
[Get-XrmOrganization](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganization.md)|Get Organization object.<br/>Retrieve default organization record from target instance.
[Get-XrmOrganizationClientFeatures](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganizationClientFeatures.md)|Get Organization Client Features.<br/>Retrieve all or specified client features from default organization (see : Get-XrmOrganization)
[Get-XrmOrganizationDbSetting](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganizationDbSetting.md)|Get Organization setting.<br/>Retrieve organization setting (orgdbsetting) from target instance.
[Get-XrmOrganizationFeatures](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmOrganizationFeatures.md)|Get Organization Features<br/>Retrieve all or specified features from default organization (see : Get-XrmOrganization)
[Set-XrmEnvironmentVariableValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmEnvironmentVariableValue.md)|Set environment variable value.<br/>Create or update the current value of a Dataverse environment variable by its schema name.
[Set-XrmOrganizationClientFeature](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmOrganizationClientFeature.md)|Set Organization Client Feature.<br/>Define specific client feature for default organization (see : Get-XrmOrganization)
[Set-XrmOrganizationDbSetting](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmOrganizationDbSetting.md)|Set Organization setting.<br/>Add or update orgdbsetting value.
[Set-XrmOrganizationFeature](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmOrganizationFeature.md)|Set Organization Feature.<br/>Define specific feature for default organization (see : Get-XrmOrganization)
# `Plugins` commands

Command|Synopsis
-------|-----------
[Disable-XrmPluginStep](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Disable-XrmPluginStep.md)|Disable a plugin step.<br/>Deactivate a given SDK message processing step.
[Enable-XrmPluginStep](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Enable-XrmPluginStep.md)|Enable a plugin step.<br/>Activate a given SDK message processing step.
[Get-XrmPluginTraces](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPluginTraces.md)|Retrieve plugin traces.<br/>Get latest plugin trace log from target instance.
[Remove-XrmPluginsFromAssembly](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmPluginsFromAssembly.md)|Remove Plugins Steps and Types From Assembly.<br/>Uninstall all steps and types from plugin assembly.
[Upsert-XrmAssembly](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmAssembly.md)|Create or update plugin / workflow assembly.<br/>Add new or update existing assembly content from local dll file.
# `Query` commands

Command|Synopsis
-------|-----------
[Add-XrmQueryCondition](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryCondition.md)|Add filter to given query expression.<br/>Add new condition criteria to given query expression.
[Add-XrmQueryLink](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryLink.md)|Add link entity to given query expression.<br/>Add new link to given query expression to join to another table / entity.
[Add-XrmQueryLinkColumns](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmQueryLinkColumns.md)|Add columns to a link entity.<br/>Add one or more columns to a given link entity for retrieval.
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
[Add-XrmConnectionRole](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmConnectionRole.md)|Create a new connection role in Microsoft Dataverse.<br/>Create a connectionrole record.
[Add-XrmSecurityRole](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmSecurityRole.md)|Create a new security role.<br/>Create a new security role (role) record in Microsoft Dataverse.
[Add-XrmSecurityRolePrivileges](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmSecurityRolePrivileges.md)|Add privileges to a security role.<br/>Add one or more privileges to an existing security role using the AddPrivilegesRole SDK message.
[Add-XrmUserRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmUserRoles.md)|Add security roles to user.<br/>Assign one or multiple roles to given user.
[Add-XrmUserToTeam](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmUserToTeam.md)|Add user to a team.<br/>Associate a system user to a specified team using the teammembership_association relationship.
[Copy-XrmSecurityRole](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Copy-XrmSecurityRole.md)|Copy a security role.<br/>Clone an existing security role by creating a new role and copying all privileges from the source role using the ReplacePrivilegesRole SDK message.
[Get-XrmConnectionRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmConnectionRoles.md)|Retrieve connection roles from Microsoft Dataverse.<br/>Get connectionrole records with optional name or category filter.
[Get-XrmRolePrivileges](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRolePrivileges.md)|Retrieve security role privileges.<br/>Get role privileges from given role.
[Get-XrmRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRoles.md)|Retrieve security roles.<br/>Get security roles according to different criterias.
[Get-XrmRootBusinessUnit](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRootBusinessUnit.md)|Retrieve root business unit.<br/>Get top  business unit of organization.
[Get-XrmUser](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUser.md)|Retrieve user.<br/>Get system user according to given ID with expected columns.
[Get-XrmUserBusinessUnit](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUserBusinessUnit.md)|Retrieve user business unit.<br/>Get user parent business unit.
[Get-XrmUserRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUserRoles.md)|Retrieve user assigned security roles.<br/>Get security roles associated to given user.
[Get-XrmUsers](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUsers.md)|Retrieve users.<br/>Get all system users from instance.
[Get-XrmUsersFromTeam](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUsersFromTeam.md)|Retrieve users from a team.<br/>Get all system users that are members of a specified team.
[Get-XrmUsersRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUsersRoles.md)|Retrieve assigned security roles for all users.<br/>Get all users with associated roles. This could help to determine unused roles or bad configurations.
[Get-XrmWhoAmI](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmWhoAmI.md)|Retrieve current user id.<br/>Get system user unique identifier.
[New-XrmPrincipalAccess](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmPrincipalAccess.md)|Create a PrincipalAccess object.<br/>Instantiate a Microsoft.Crm.Sdk.Messages.PrincipalAccess object with the specified principal and access rights.
[Remove-XrmConnectionRole](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmConnectionRole.md)|Delete a connection role from Microsoft Dataverse.<br/>Remove a connectionrole record.
[Remove-XrmSecurityRole](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmSecurityRole.md)|Delete a security role.<br/>Delete a security role (role) record from Microsoft Dataverse.
[Remove-XrmSecurityRolePrivilege](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmSecurityRolePrivilege.md)|Remove a privilege from a security role.<br/>Remove a single privilege from an existing security role using the RemovePrivilegeRole SDK message.
[Remove-XrmUserFromTeam](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmUserFromTeam.md)|Remove user from a team.<br/>Disassociate a system user from a specified team using the teammembership_association relationship.
[Remove-XrmUserRoles](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmUserRoles.md)|Remove security roles to user.<br/>Unassign one or multiple roles to given user.
[Revoke-XrmRecordAccess](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Revoke-XrmRecordAccess.md)|Revoke access on a record for a user or team.<br/>Remove all granted access rights on a Dataverse record for a specified principal (user or team).
[Set-XrmSecurityRole](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmSecurityRole.md)|Update a security role.<br/>Update an existing security role (role) record in Microsoft Dataverse.
[Set-XrmSecurityRolePrivileges](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmSecurityRolePrivileges.md)|Replace all privileges on a security role.<br/>Replace the entire privilege set of an existing security role using the ReplacePrivilegesRole SDK message.<br/>This removes all current privileges and sets only the ones provided.
[Share-XrmRecord](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Share-XrmRecord.md)|Share a record with a user or team.<br/>Grant access rights on a Dataverse record to a specified principal (user or team).
# `Components` commands

Command|Synopsis
-------|-----------
[Add-XrmSolutionComponent](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmSolutionComponent.md)|Add Solution Component.<br/>Add given component to specified solution.
[Add-XrmSolutionComponents](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmSolutionComponents.md)|Add multiple components to a solution.<br/>Adds a batch of components to the specified unmanaged solution and returns<br/>one result object per component.
[Copy-XrmSolutionComponents](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Copy-XrmSolutionComponents.md)|Copy Solution Components.<br/>Add all components from source solution to target one.
[Get-XrmSolutionComponentName](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionComponentName.md)|Get Solution Component name from Id.<br/>Retrieve component name from its number.
[Get-XrmSolutionComponents](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionComponents.md)|Get Solution Components.<br/>Retrieve components from given solution and expected types.
[Remove-XrmSolutionComponent](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmSolutionComponent.md)|Remove a component from an unmanaged solution.<br/>Remove given component from specified unmanaged solution using the RemoveSolutionComponent SDK message.<br/>This does not delete the component from the environment, it only removes it from the solution.
[Update-XrmSolutionComponent](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmSolutionComponent.md)|Update a solution component.<br/>Update a component in an unmanaged solution using the UpdateSolutionComponent SDK message.
# `Layers` commands

Command|Synopsis
-------|-----------
[Clear-XrmActiveCustomizations](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Clear-XrmActiveCustomizations.md)|Clear active customizations for given solution components.<br/>Performs a cleaning on Active Layer to remove unmanaged customizations for given component types.
[Get-XrmCustomizedSolutionComponents](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmCustomizedSolutionComponents.md)|Get customized solution components from Active layer.<br/>Retrieves solution components from a solution, then keeps only components<br/>with meaningful Active-layer customizations.
[Remove-XrmActiveCustomizations](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmActiveCustomizations.md)|Remove active customizations.<br/>Performs a cleaning on Active Layer to remove unmanaged customizations for given component.
[Test-XrmComponentCustomization](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmComponentCustomization.md)|Test active-layer customization for a solution component.<br/>Checks whether a component has meaningful customizations in the Active layer<br/>by querying msdyn_componentlayer and parsing msdyn_changes.
# `Solutions` commands

Command|Synopsis
-------|-----------
[Add-XrmPublisher](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmPublisher.md)|Create a new publisher in Microsoft Dataverse.<br/>Create a publisher record with the specified unique name, display name, prefix, and option value prefix.
[Add-XrmSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmSolution.md)|Create a new unmanaged solution in Microsoft Dataverse.<br/>Create an unmanaged solution with the specified unique name, display name, version, and publisher.
[Clear-XrmSolutions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Clear-XrmSolutions.md)|Select solutions to uninstall.<br/>Select solutions (managed or unmanaged) and delete them.
[Export-XrmSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmSolution.md)|Export solution.<br/>Export given solution with given settings.
[Get-XrmBasicSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmBasicSolution.md)|Retrieve basic solution record.<br/>Get basic solution with specified column.
[Get-XrmPublisher](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPublisher.md)|Retrieve publisher record from Microsoft Dataverse.<br/>Get a publisher by its unique name with expected columns.
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
[Test-XrmPublisher](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmPublisher.md)|Verify whether a Dataverse publisher exists.<br/>Return $true when a publisher exists for the specified unique name.
[Test-XrmSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmSolution.md)|Verify whether a Dataverse solution exists.<br/>Return $true when a solution exists for the specified unique name.
[Uninstall-XrmSolution](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Uninstall-XrmSolution.md)|Uninstall a solution from Microsoft Dataverse.<br/>Delete a solution (managed or unmanaged) from the environment by its unique name.<br/>Uses the UninstallSolutionAsync SDK message to avoid timeout issues, then monitors<br/>the async operation via Watch-XrmAsynchOperation until completion.
[Watch-XrmCurrentSolutionImport](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Watch-XrmCurrentSolutionImport.md)|Monitor current solution import.<br/>Poll latest solution import status until its done and display progress.
# `SQL` commands

Command|Synopsis
-------|-----------
[Assert-XrmTdsEndpointEnabled](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Assert-XrmTdsEndpointEnabled.md)|Check if TDS endpoint is enabled.<br/>Assert orgdbsettings EnableTDSEndpoint parameter is true to allow SQL commands thru TDS Endpoint.
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
[New-XrmEntity](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntity.md)|Initialize Entity object instance.<br/>Create a new Microsoft Dataverse Entity object.
[New-XrmEntityCollection](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntityCollection.md)|Initialize EntityCollection object instance.<br/>Get new Entity Collection object from entities array.
[New-XrmEntityReference](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntityReference.md)|Initialize EntityReference object instance.<br/>Get new EntityReference object from lookup information.
[New-XrmLabel](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmLabel.md)|Create a Label object for Dataverse metadata.<br/>Build a Microsoft.Xrm.Sdk.Label from a text value and language code.
[New-XrmMoney](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmMoney.md)|Initialize Money object instance.<br/>Get new money object from given decimal value.
[New-XrmOption](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmOption.md)|Build an OptionMetadata object for Dataverse option sets.<br/>Creates a configured Microsoft.Xrm.Sdk.Metadata.OptionMetadata object that can be reused<br/>when creating global option sets, local choice columns, or synchronizing option values.
[New-XrmOptionSetValue](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmOptionSetValue.md)|Initialize OptionSetValue object instance.<br/>Get new OptionSetValue object from given int value.
[New-XrmOptionSetValues](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmOptionSetValues.md)|Initialize OptionSetValueCollection object instance.<br/>Get new OptionSetValueCollection object from given int value array.
[New-XrmRolePrivilege](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmRolePrivilege.md)|Create a RolePrivilege object.<br/>Instantiate a RolePrivilege object used to define a privilege with its depth for security role operations.
# `Utilities` commands

Command|Synopsis
-------|-----------
[Add-XrmFolder](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmFolder.md)|Add folder in given path if it doesn't exists.<br/>Create given folder if not exist and return sub folder full path.
[Get-XrmAuthTypes](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAuthTypes.md)|Retrieve authentication type names.<br/>Get available authentication types.
[Get-XrmBase64](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmBase64.md)|Get base 64 from file content.<br/>Read given file and return its content as base64 content.
[Get-XrmRegions](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRegions.md)|Retrieve region names.<br/>Get available datacenter regions.
[Set-XrmCredentials](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmCredentials.md)|Initialize PSCredential object.<br/>Create PSCredential from given login and password.
[Split-XrmCollection](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Split-XrmCollection.md)|Split given collection into specified sized collections.<br/>Extract chunk collections from given one.
# `Views` commands

Command|Synopsis
-------|-----------
[Get-XrmQueryFromFetch](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmQueryFromFetch.md)|Retrieve query expression from fetch Xml.<br/>Convert FetchXml to QueryExpression.
[Get-XrmRecordsFromView](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecordsFromView.md)|Retrieve records from a view.<br/>Get records according to given view name.
[Get-XrmViews](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmViews.md)|Retrieve savedquery records.<br/>Get all saved query according to entity name and predefined columns.
[Test-XrmView](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmView.md)|Validate a saved query (view) in Microsoft Dataverse.<br/>Check if a saved query (view) definition is valid using the ValidateSavedQuery SDK action.
# `WebResources` commands

Command|Synopsis
-------|-----------
[Sync-XrmWebResources](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Sync-XrmWebResources.md)|Synchronize a webresource folder to Microsoft Dataverse.<br/>Create or update each webresource content based on local directory.
[Upsert-XrmWebResource](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmWebResource.md)|Create or update webresource.<br/>Check if webresource exists or not. If not exists create it and add it to specified solution.<br/>If webresource exists, compare content and update it if different.
# `Workflows` commands

Command|Synopsis
-------|-----------
[Apply-XrmBusinessProcessFlowStage](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Apply-XrmBusinessProcessFlowStage.md)|Apply a business process flow stage to a record.<br/>Set or create a BPF instance for a target record at a specified stage. If a BPF record already exists, <br/>updates the active stage and traversed path. Otherwise, creates a new BPF instance.
[Disable-XrmWorkflow](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Disable-XrmWorkflow.md)|Disable a workflow.<br/>Deactivate given workflow.
[Enable-XrmWorkflow](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Enable-XrmWorkflow.md)|Enable a workflow.<br/>Activate given workflow.
[Get-XrmBusinessProcessFlowStage](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmBusinessProcessFlowStage.md)|Retrieve a business process flow stage.<br/>Get a process stage record by stage name and process identifier.
[Get-XrmWorkflows](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmWorkflows.md)|Retrieve workflows.<br/>Get workflows with expected columns.
[Invoke-XrmWorkflow](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmWorkflow.md)|Execute a workflow on a specific record.<br/>Trigger an on-demand workflow (classic workflow) on a target record using the ExecuteWorkflow SDK message.
# `_Internals` commands

Command|Synopsis
-------|-----------
[Sync-XrmOptionSetOptionsInternal](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Sync-XrmOptionSetOptionsInternal.md)|<br/>
[Test-XrmNotFoundError](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmNotFoundError.md)|<br/>

