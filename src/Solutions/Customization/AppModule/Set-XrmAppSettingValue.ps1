<#
    .SYNOPSIS
    Set model-driven app setting value.

    .DESCRIPTION
    Set a named setting for a specific model-driven app by calling Set-XrmSettingValue with the app scope.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppUniqueName
    Unique name of the model-driven app (mandatory).

    .PARAMETER SettingName
    Unique name of the setting to set (e.g. "OverrideAppHeaderColor").

    .PARAMETER Value
    Value to assign to the setting.

    .PARAMETER SolutionUniqueName
    Unique name of the solution to associate the change with. Optional.

    .OUTPUTS
    [System.Void]

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $xrmClient | Set-XrmAppSettingValue -AppUniqueName "msdyn_FieldService" -SettingName "OverrideAppHeaderColor" -Value "#FF0000";

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $xrmClient | Set-XrmAppSettingValue -AppUniqueName "msdyn_FieldService" -SettingName "OverrideAppHeaderColor" -Value "#FF0000" -SolutionUniqueName "MySolution";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmAppSettingValue.md
#>
function Set-XrmAppSettingValue {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AppUniqueName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SettingName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]
        $Value,

        [Parameter(Mandatory = $false)]
        [String]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $setParams = @{
            "XrmClient"       = $XrmClient;
            "SettingName"     = $SettingName;
            "Value"           = $Value;
            "AppUniqueName"   = $AppUniqueName;
        };

        if ($PSBoundParameters.ContainsKey("SolutionUniqueName")) {
            $setParams["SolutionUniqueName"] = $SolutionUniqueName;
        }

        Set-XrmSettingValue @setParams;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmAppSettingValue -Alias *;
