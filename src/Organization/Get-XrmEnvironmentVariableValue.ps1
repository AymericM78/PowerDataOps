<#
    .SYNOPSIS
    Retrieve environment variable value.

    .DESCRIPTION
    Get the current value of a Dataverse environment variable by its schema name.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Environment variable definition schema name.

    .OUTPUTS
    String. Current environment variable value or default value if no current value is set.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $value = Get-XrmEnvironmentVariableValue -XrmClient $xrmClient -Name "df_SynchTrackingFunctionUrl";
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
        $Name
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $query = New-XrmQueryExpression -LogicalName "environmentvariabledefinition" -Columns "defaultvalue", "schemaname" -TopCount 1;
        $query | Add-XrmQueryCondition -Field "schemaname" -Condition Equal -Values @($Name) | Out-Null;
        $link = $query | Add-XrmQueryLink -ToEntityName "environmentvariablevalue" -FromAttributeName "environmentvariabledefinitionid" -ToAttributeName "environmentvariabledefinitionid" -JoinOperator LeftOuter -Alias "val";
        $link.Columns = New-Object "Microsoft.Xrm.Sdk.Query.ColumnSet" @(, [string[]]@("value"));

        $results = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $query;
        $record = $results | Select-Object -First 1;

        if (-not $record) {
            throw "Environment variable definition '$Name' not found.";
        }

        $currentValue = $record."val.value";
        if ($currentValue) {
            $currentValue;
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
