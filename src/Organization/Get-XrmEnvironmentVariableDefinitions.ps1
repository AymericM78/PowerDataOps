<#
    .SYNOPSIS
    List the environment variables of the organization.

    .DESCRIPTION
    Return one summary per environment variable definition (see Get-XrmEnvironmentVariable): SchemaName, DisplayName, Type, DefinitionId, DefaultValue, ValueId, Value, EffectiveValue, HasOverride.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Type
    Types to keep: String, Number, Boolean, JSON, DataSource, Secret. (Default: all)

    .PARAMETER Prefix
    Keep only the schema names starting with this prefix (e.g. a publisher prefix "new_"). (Default: all)

    .OUTPUTS
    PSCustomObject. One summary per environment variable.

    .EXAMPLE
    Get-XrmEnvironmentVariableDefinitions -XrmClient $xrmClient -Prefix "new_" | Format-Table SchemaName, EffectiveValue, HasOverride;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEnvironmentVariableDefinitions.md
#>
function Get-XrmEnvironmentVariableDefinitions {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateSet("String", "Number", "Boolean", "JSON", "DataSource", "Secret")]
        [String[]]
        $Type,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Prefix
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $hasType = $PSBoundParameters.ContainsKey('Type');
        $hasPrefix = $PSBoundParameters.ContainsKey('Prefix');
        Get-XrmEnvironmentVariablesInternal -XrmClient $XrmClient | Where-Object {
            (-not $hasType -or $Type -contains $_.Type) -and (-not $hasPrefix -or $_.SchemaName.StartsWith($Prefix, [System.StringComparison]::OrdinalIgnoreCase));
        };
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmEnvironmentVariableDefinitions -Alias *;
