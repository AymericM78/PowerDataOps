<#
    .SYNOPSIS
    Retrieve environment variable value.

    .DESCRIPTION
    Get the current value of a Dataverse environment variable by its schema name.
    When a value record (override) exists, its value is returned, even when it is empty; otherwise the definition default value is returned.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Environment variable definition schema name.

    .PARAMETER IfExists
    Return $null when the definition does not exist, instead of raising an error.

    .OUTPUTS
    String. Current environment variable value or default value if no current value is set.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $value = Get-XrmEnvironmentVariableValue -XrmClient $xrmClient -Name "df_SynchTrackingFunctionUrl";

    .EXAMPLE
    $value = Get-XrmEnvironmentVariableValue -XrmClient $xrmClient -Name "df_OptionalSetting" -IfExists;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEnvironmentVariableValue.md
#>
function Get-XrmEnvironmentVariableValue {
    [CmdletBinding()]
    [OutputType([String])]
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
        $query = New-XrmQueryExpression -LogicalName "environmentvariabledefinition" -Columns "defaultvalue", "schemaname" -TopCount 1;
        $query | Add-XrmQueryCondition -Field "schemaname" -Condition Equal -Values @($Name) | Out-Null;
        $link = $query | Add-XrmQueryLink -ToEntityName "environmentvariablevalue" -FromAttributeName "environmentvariabledefinitionid" -ToAttributeName "environmentvariabledefinitionid" -JoinOperator LeftOuter -Alias "val";
        $link | Add-XrmQueryLinkColumns -Columns "value", "environmentvariablevalueid" | Out-Null;

        $results = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $query;
        $record = $results | Select-Object -First 1;

        if (-not $record) {
            if ($IfExists) {
                return $null;
            }
            throw "Environment variable definition '$Name' not found.";
        }

        # An override exists when the left outer join returned a value record: return it even when empty
        if ($null -ne $record."val.environmentvariablevalueid") {
            [string]$record."val.value";
        }
        else {
            $record.defaultvalue;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmEnvironmentVariableValue -Alias *;
