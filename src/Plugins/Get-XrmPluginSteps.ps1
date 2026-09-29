<#
    .SYNOPSIS
    Retrieve plug-in steps (SDK message processing steps).

    .DESCRIPTION
    Get sdkmessageprocessingstep rows, optionally filtered by assembly, table, message and state.
    Each row also carries AssemblyName, PluginTypeName, MessageName and EntityLogicalName ("none" for a message that is not bound to a table).
    CustomOnly keeps the steps registered by customers or partners: visible steps (ishidden false, customizationlevel 1) whose plug-in assembly name does not start with "Microsoft.". The platform refuses to modify the steps registered by Microsoft.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AssemblyName
    Plug-in assembly name (pluginassembly.name, without version). (Default: all)

    .PARAMETER EntityLogicalName
    Table logical name of the step filter (e.g. "account"). (Default: all)

    .PARAMETER MessageName
    SDK message name (e.g. "Create", "Update"). (Default: all)

    .PARAMETER ActiveOnly
    Keep the enabled steps only.

    .PARAMETER CustomOnly
    Keep the steps registered by customers or partners only (see description).

    .PARAMETER Columns
    Step columns to return. (Default: name, stage, mode, rank, statecode, filteringattributes, eventhandler, sdkmessageid, sdkmessagefilterid, ismanaged, customizationlevel, ishidden)

    .OUTPUTS
    PSCustomObject[]. Step rows (XrmObject) with AssemblyName, PluginTypeName, MessageName and EntityLogicalName.

    .EXAMPLE
    $steps = Get-XrmPluginSteps -XrmClient $xrmClient -EntityLogicalName "account" -MessageName "Update" -ActiveOnly -CustomOnly;
    $steps | Select-Object name, PluginTypeName, stage, rank;

    .EXAMPLE
    # Disable the steps of an assembly before a data migration
    Get-XrmPluginSteps -XrmClient $xrmClient -AssemblyName "Contoso.Plugins" -ActiveOnly | ForEach-Object { Disable-XrmPluginStep -XrmClient $xrmClient -PluginStepReference $_.Reference };

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPluginSteps.md
#>
function Get-XrmPluginSteps {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AssemblyName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $MessageName,

        [Parameter(Mandatory = $false)]
        [switch]
        $ActiveOnly,

        [Parameter(Mandatory = $false)]
        [switch]
        $CustomOnly,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("name", "stage", "mode", "rank", "statecode", "filteringattributes", "eventhandler", "sdkmessageid", "sdkmessagefilterid", "ismanaged", "customizationlevel", "ishidden")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $query = New-XrmQueryExpression -LogicalName "sdkmessageprocessingstep" -Columns $Columns;
        if ($ActiveOnly) {
            $query = $query | Add-XrmQueryCondition -Field "statecode" -Condition Equal -Values 0;
        }
        if ($CustomOnly) {
            $query = $query | Add-XrmQueryCondition -Field "ishidden" -Condition Equal -Values $false;
            $query = $query | Add-XrmQueryCondition -Field "customizationlevel" -Condition Equal -Values 1;
        }

        # Inner joins when filtered, outer joins otherwise (service endpoint steps have no plug-in type)
        $typeJoin = $(if ($PSBoundParameters.ContainsKey('AssemblyName')) { [Microsoft.Xrm.Sdk.Query.JoinOperator]::Inner } else { [Microsoft.Xrm.Sdk.Query.JoinOperator]::LeftOuter });
        $typeLink = $query | Add-XrmQueryLink -ToEntityName "plugintype" -FromAttributeName "eventhandler" -ToAttributeName "plugintypeid" -JoinOperator $typeJoin -Alias "pt";
        $typeLink | Add-XrmQueryLinkColumns -Columns "assemblyname", "typename" | Out-Null;
        if ($PSBoundParameters.ContainsKey('AssemblyName')) {
            $typeLink | Add-XrmQueryLinkCondition -Field "assemblyname" -Condition Equal -Values $AssemblyName | Out-Null;
        }

        $messageJoin = $(if ($PSBoundParameters.ContainsKey('MessageName')) { [Microsoft.Xrm.Sdk.Query.JoinOperator]::Inner } else { [Microsoft.Xrm.Sdk.Query.JoinOperator]::LeftOuter });
        $messageLink = $query | Add-XrmQueryLink -ToEntityName "sdkmessage" -FromAttributeName "sdkmessageid" -ToAttributeName "sdkmessageid" -JoinOperator $messageJoin -Alias "msg";
        $messageLink | Add-XrmQueryLinkColumns -Columns "name" | Out-Null;
        if ($PSBoundParameters.ContainsKey('MessageName')) {
            $messageLink | Add-XrmQueryLinkCondition -Field "name" -Condition Equal -Values $MessageName | Out-Null;
        }

        $filterJoin = $(if ($PSBoundParameters.ContainsKey('EntityLogicalName')) { [Microsoft.Xrm.Sdk.Query.JoinOperator]::Inner } else { [Microsoft.Xrm.Sdk.Query.JoinOperator]::LeftOuter });
        $filterLink = $query | Add-XrmQueryLink -ToEntityName "sdkmessagefilter" -FromAttributeName "sdkmessagefilterid" -ToAttributeName "sdkmessagefilterid" -JoinOperator $filterJoin -Alias "flt";
        $filterLink | Add-XrmQueryLinkColumns -Columns "primaryobjecttypecode" | Out-Null;
        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $filterLink | Add-XrmQueryLinkCondition -Field "primaryobjecttypecode" -Condition Equal -Values $EntityLogicalName | Out-Null;
        }

        $steps = $XrmClient | Get-XrmMultipleRecords -Query $query -AsEntity -AsArray;
        foreach ($step in $steps) {
            $linked = @{};
            foreach ($alias in "pt.assemblyname", "pt.typename", "msg.name", "flt.primaryobjecttypecode") {
                $linked[$alias] = $(if ($step.Contains($alias) -and $null -ne $step[$alias]) { [string]$step[$alias].Value } else { $null });
            }
            $assemblyNameValue = $linked["pt.assemblyname"];
            if ($CustomOnly -and $assemblyNameValue -and $assemblyNameValue.StartsWith("Microsoft.", [StringComparison]::OrdinalIgnoreCase)) {
                continue;
            }

            $row = $step | ConvertTo-XrmObject;
            $row | Add-Member -MemberType NoteProperty -Name "AssemblyName" -Value $assemblyNameValue;
            $row | Add-Member -MemberType NoteProperty -Name "PluginTypeName" -Value $linked["pt.typename"];
            $row | Add-Member -MemberType NoteProperty -Name "MessageName" -Value $linked["msg.name"];
            $row | Add-Member -MemberType NoteProperty -Name "EntityLogicalName" -Value $linked["flt.primaryobjecttypecode"];
            $row;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmPluginSteps -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmPluginSteps -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
