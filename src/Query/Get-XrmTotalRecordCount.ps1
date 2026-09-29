<#
    .SYNOPSIS
    Returns total number of rows in given entity / table.

    .DESCRIPTION
    Returns data on the total number of records for specific entities. (RetrieveTotalRecordCount)
    These counts come from a periodic snapshot: use Get-XrmRecordCount for an exact, filtered count.
    One table the platform refuses makes the whole request fail; with SkipRefused, the tables are then asked one by one and the refused ones are skipped with a warning.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalNames
    The logical names of the entities to include in the query.

    .PARAMETER SkipRefused
    Skip (with a warning) the tables the platform refuses to count, instead of failing the whole call.

    .PARAMETER AsHashtable
    Return a hashtable: logical name = count.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityRecordCountCollection (enumerated as logical name / count pairs). With AsHashtable: Hashtable.

    .EXAMPLE
    $counts = Get-XrmTotalRecordCount -XrmClient $xrmClient -LogicalNames "account", "contact" -AsHashtable;
    Write-Host "$($counts.account) accounts";

    .EXAMPLE
    $counts = Get-XrmTotalRecordCount -XrmClient $xrmClient -LogicalNames $allTables -SkipRefused -AsHashtable;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmTotalRecordCount.md
#>
function Get-XrmTotalRecordCount {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityRecordCountCollection], [Hashtable])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $LogicalNames,

        [Parameter(Mandatory = $false)]
        [switch]
        $SkipRefused,

        [Parameter(Mandatory = $false)]
        [switch]
        $AsHashtable
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $counts = $null;
        if (-not $SkipRefused) {
            $retrieveTotalRecordCountRequest = New-XrmRequest -Name "RetrieveTotalRecordCount";
            $retrieveTotalRecordCountRequest | Add-XrmRequestParameter -Name "EntityNames" -Value $LogicalNames | Out-Null;
            $response = $XrmClient | Invoke-XrmRequest -Request $retrieveTotalRecordCountRequest;
            $counts = $response.Results["EntityRecordCountCollection"];
        }
        else {
            try {
                $retrieveTotalRecordCountRequest = New-XrmRequest -Name "RetrieveTotalRecordCount";
                $retrieveTotalRecordCountRequest | Add-XrmRequestParameter -Name "EntityNames" -Value $LogicalNames | Out-Null;
                $response = $XrmClient | Invoke-XrmRequest -Request $retrieveTotalRecordCountRequest;
                $counts = $response.Results["EntityRecordCountCollection"];
            }
            catch {
                # One refused table fails the whole request: ask them one by one
                $counts = [Microsoft.Xrm.Sdk.EntityRecordCountCollection]::new();
                foreach ($logicalName in $LogicalNames) {
                    try {
                        $singleRequest = New-XrmRequest -Name "RetrieveTotalRecordCount";
                        $singleRequest | Add-XrmRequestParameter -Name "EntityNames" -Value ([string[]]@($logicalName)) | Out-Null;
                        $singleResponse = $XrmClient | Invoke-XrmRequest -Request $singleRequest;
                        foreach ($pair in $singleResponse.Results["EntityRecordCountCollection"]) {
                            $counts.Add($pair.Key, $pair.Value);
                        }
                    }
                    catch {
                        Write-Warning "Table '$logicalName' skipped: $($_.Exception.Message)";
                    }
                }
            }
        }

        if ($AsHashtable) {
            $table = @{};
            foreach ($pair in $counts) {
                $table[$pair.Key] = $pair.Value;
            }
            return $table;
        }
        $counts;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmTotalRecordCount -Alias *;


Register-ArgumentCompleter -CommandName Get-XrmTotalRecordCount -ParameterName "LogicalNames" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
