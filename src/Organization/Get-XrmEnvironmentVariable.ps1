<#
    .SYNOPSIS
    Retrieve an environment variable: definition, value and effective value.

    .DESCRIPTION
    Read an environment variable definition and its value record (override) in one query, and return a summary:
    SchemaName, DisplayName, Type (String, Number, Boolean, JSON, DataSource, Secret), DefinitionId, DefaultValue, ValueId, Value, EffectiveValue, HasOverride.
    EffectiveValue is the override when a value record exists (even empty), else the default value.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Environment variable definition schema name.

    .PARAMETER IfExists
    Return $null when the definition does not exist, instead of raising an error.

    .OUTPUTS
    PSCustomObject. SchemaName, DisplayName, Type, DefinitionId, DefaultValue, ValueId, Value, EffectiveValue, HasOverride.

    .EXAMPLE
    $variable = Get-XrmEnvironmentVariable -XrmClient $xrmClient -Name "new_ApiUrl";
    if ($variable.HasOverride) { Write-Host "Overridden: $($variable.Value)"; }

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEnvironmentVariable.md
#>
function Get-XrmEnvironmentVariable {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $false)]
        [switch]
        $IfExists
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $variable = Get-XrmEnvironmentVariablesInternal -XrmClient $XrmClient -Name $Name | Select-Object -First 1;
        if (-not $variable) {
            if ($IfExists) {
                return $null;
            }
            throw "Environment variable definition '$Name' not found.";
        }
        $variable;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmEnvironmentVariable -Alias *;
