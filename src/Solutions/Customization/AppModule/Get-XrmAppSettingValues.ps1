<#
    .SYNOPSIS
    Retrieve the settings values of a model-driven app.

    .DESCRIPTION
    Read the app-level setting values (appsetting) of an app, published or not: the reading counterpart of Set-XrmAppSettingValue.
    A value saved with Set-XrmAppSettingValue stays in the unpublished layer until the app is published: both layers are read, the unpublished value wins.
    Returns one object per value set on the app: SettingName (setting definition unique name), Value, DefaultValue, AppSettingId.
    Settings without an app value are not returned: their effective value is the organization value or the default one.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppUniqueName
    Unique name of the app (appmodule).

    .PARAMETER SettingName
    Setting definition unique names to keep. (Default: all)

    .OUTPUTS
    PSCustomObject[]. SettingName, Value, DefaultValue, AppSettingId.

    .EXAMPLE
    Get-XrmAppSettingValues -XrmClient $xrmClient -AppUniqueName "contoso_sales" | Format-Table SettingName, Value, DefaultValue;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAppSettingValues.md
#>
function Get-XrmAppSettingValues {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AppUniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $SettingName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $apps = @(Get-XrmAppModules -XrmClient $XrmClient -UniqueName $AppUniqueName -Columns "appmoduleid");
        if ($apps.Count -eq 0) {
            $apps = @(Get-XrmAppModules -XrmClient $XrmClient -UniqueName $AppUniqueName -Columns "appmoduleid" -Unpublished);
        }
        if ($apps.Count -eq 0) {
            throw "App '$AppUniqueName' not found.";
        }

        $query = New-XrmQueryExpression -LogicalName "appsetting" -Columns "value";
        $query = $query | Add-XrmQueryCondition -Field "parentappmoduleid" -Condition Equal -Values $apps[0].Id;
        $definitionLink = $query | Add-XrmQueryLink -ToEntityName "settingdefinition" -FromAttributeName "settingdefinitionid" -ToAttributeName "settingdefinitionid" -Alias "def";
        $definitionLink | Add-XrmQueryLinkColumns -Columns "uniquename", "defaultvalue" | Out-Null;
        if ($PSBoundParameters.ContainsKey('SettingName')) {
            $definitionLink | Add-XrmQueryLinkCondition -Field "uniquename" -Condition In -Values $SettingName | Out-Null;
        }

        # A value saved on an app lives in the unpublished layer until the app is published: read both, the unpublished one wins
        $rowsById = [ordered]@{};
        foreach ($row in @($XrmClient | Get-XrmMultipleComponents -Query $query)) { $rowsById[$row.Id] = $row; }
        foreach ($row in @($XrmClient | Get-XrmMultipleComponents -Query $query -Unpublished)) { $rowsById[$row.Id] = $row; }
        foreach ($row in $rowsById.Values) {
            [PSCustomObject]@{
                SettingName  = $row."def.uniquename";
                Value        = [string]$row.value;
                DefaultValue = $row."def.defaultvalue";
                AppSettingId = $row.Id;
            };
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmAppSettingValues -Alias *;
