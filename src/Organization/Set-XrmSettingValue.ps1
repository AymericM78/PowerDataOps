<#
    .SYNOPSIS
    Set environment or app setting value.

    .DESCRIPTION
    Call the SaveSettingValue SDK action to create or update a named setting at environment or app level.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SettingName
    Unique name of the setting to set (e.g. "OverrideAppHeaderColor").

    .PARAMETER Value
    Value to assign to the setting.

    .PARAMETER AppUniqueName
    Unique name of the model-driven app this setting applies to. Omit for environment-level setting.

    .PARAMETER SolutionUniqueName
    Unique name of the solution to associate the change with. Optional.

    .OUTPUTS
    [System.Void]

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $xrmClient | Set-XrmSettingValue -SettingName "OverrideAppHeaderColor" -Value "#FF0000";

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $xrmClient | Set-XrmSettingValue -SettingName "OverrideAppHeaderColor" -Value "#FF0000" -AppUniqueName "msdyn_FieldService" -SolutionUniqueName "MySolution";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmSettingValue.md
#>
function Set-XrmSettingValue {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

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
        $AppUniqueName,

        [Parameter(Mandatory = $false)]
        [String]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "SaveSettingValue";
        $request | Add-XrmRequestParameter -Name "SettingName" -Value $SettingName | Out-Null;
        $request | Add-XrmRequestParameter -Name "Value" -Value $Value | Out-Null;

        if ($PSBoundParameters.ContainsKey("AppUniqueName") -and $AppUniqueName) {
            $request | Add-XrmRequestParameter -Name "AppUniqueName" -Value $AppUniqueName | Out-Null;
        }

        if ($PSBoundParameters.ContainsKey("SolutionUniqueName") -and $SolutionUniqueName) {
            $request | Add-XrmRequestParameter -Name "SolutionUniqueName" -Value $SolutionUniqueName | Out-Null;
        }

        $XrmClient | Invoke-XrmRequest -Request $request;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmSettingValue -Alias *;
