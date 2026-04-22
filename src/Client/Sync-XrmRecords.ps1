<#
    .SYNOPSIS
    Synchronize records between two Dataverse instances.

    .DESCRIPTION
    Reads records from a source instance, transforms attributes according to sync options,
    then upserts records in a target instance. Supports optional two-pass dependency sync.

    .PARAMETER SourceXrmClient
    Source Dataverse connector.

    .PARAMETER TargetXrmClient
    Target Dataverse connector.

    .PARAMETER LogicalNames
    Entity logical names to synchronize.

    .PARAMETER Columns
    Columns to retrieve from source entities. Default: *

    .PARAMETER ExcludedAttributes
    Attribute logical names excluded from synchronization.

    .PARAMETER IncludeEntityReferences
    Include EntityReference attributes in synchronization.

    .PARAMETER TwoPassDependencies
    Run sync in 2 passes. First pass excludes EntityReference attributes,
    second pass includes them.

    .PARAMETER PreserveCreatedOn
    Preserve source createdon value using overriddencreatedon when available.

    .PARAMETER StateHandling
    Controls state/status handling after upsert:
    - Ignore
    - ApplyStateCode
    - ApplyStateAndStatus

    .PARAMETER BypassCustomPluginExecution
    Bypass custom plugin execution during upsert.

    .PARAMETER ContinueOnError
    Continue processing records when one record fails.

    .PARAMETER TopCount
    Limit source record retrieval.

    .PARAMETER OrderByField
    Optional order field applied to source query.

    .PARAMETER OrderType
    Query order direction when OrderByField is provided.

    .OUTPUTS
    PSCustomObject array.

    .EXAMPLE
    Sync-XrmRecords -SourceXrmClient $source -TargetXrmClient $target -LogicalNames @("account") -Columns @("name");
#>
function Sync-XrmRecords {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $SourceXrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $TargetXrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $LogicalNames,

        [Parameter(Mandatory = $false)]
        [String[]]
        $Columns = @("*"),

        [Parameter(Mandatory = $false)]
        [String[]]
        $ExcludedAttributes = @(
            "createdon",
            "modifiedon",
            "createdby",
            "modifiedby",
            "createdonbehalfby",
            "modifiedonbehalfby",
            "ownerid",
            "owningbusinessunit",
            "owninguser",
            "owningteam",
            "statecode",
            "statuscode",
            "transactioncurrencyid"
        ),

        [Parameter(Mandatory = $false)]
        [bool]
        $IncludeEntityReferences = $false,

        [Parameter(Mandatory = $false)]
        [bool]
        $TwoPassDependencies = $false,

        [Parameter(Mandatory = $false)]
        [bool]
        $PreserveCreatedOn = $true,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Ignore", "ApplyStateCode", "ApplyStateAndStatus")]
        [String]
        $StateHandling = "Ignore",

        [Parameter(Mandatory = $false)]
        [switch]
        $BypassCustomPluginExecution = $false,

        [Parameter(Mandatory = $false)]
        [bool]
        $ContinueOnError = $true,

        [Parameter(Mandatory = $false)]
        [int]
        $TopCount,

        [Parameter(Mandatory = $false)]
        [String]
        $OrderByField,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Query.OrderType]
        $OrderType = [Microsoft.Xrm.Sdk.Query.OrderType]::Descending
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        [System.Collections.ArrayList]$summary = @();

        ForEach-ObjectWithProgress -Collection $LogicalNames -OperationName "Synchronizing entities" -ScriptBlock {
            param($logicalName)

            $entityStopWatch = [System.Diagnostics.Stopwatch]::StartNew();
            $readCount = 0;
            $upsertedCount = 0;
            $failedCount = 0;
            [System.Collections.ArrayList]$errorMessages = @();

            try {
                $metadata = $TargetXrmClient | Get-XrmEntityMetadata -LogicalName $logicalName -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Attributes);
                $targetAttributeSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase);
                $updatableAttributeSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase);

                if ($metadata -and $metadata.Attributes) {
                    foreach ($attributeMetadata in $metadata.Attributes) {
                        if (-not $attributeMetadata.LogicalName) {
                            continue;
                        }

                        [void]$targetAttributeSet.Add($attributeMetadata.LogicalName);

                        $isValidForUpdate = $true;
                        if ($attributeMetadata.PSObject.Properties.Match("IsValidForUpdate").Count -gt 0) {
                            $validValue = $attributeMetadata.IsValidForUpdate;
                            if ($validValue -is [bool]) {
                                $isValidForUpdate = $validValue;
                            }
                            elseif ($validValue -and $validValue.PSObject.Properties.Match("Value").Count -gt 0) {
                                $isValidForUpdate = [bool]$validValue.Value;
                            }
                        }

                        if ($isValidForUpdate) {
                            [void]$updatableAttributeSet.Add($attributeMetadata.LogicalName);
                        }
                    }
                }

                $hasOverriddenCreatedOn = $targetAttributeSet.Contains("overriddencreatedon");
                $hasStateCode = $targetAttributeSet.Contains("statecode");
                $hasStatusCode = $targetAttributeSet.Contains("statuscode");

                $queryArguments = @{
                    "LogicalName" = $logicalName;
                    "Columns" = $Columns;
                };
                if ($PSBoundParameters.ContainsKey("TopCount")) {
                    $queryArguments["TopCount"] = $TopCount;
                }

                $query = New-XrmQueryExpression @queryArguments;
                if ($PSBoundParameters.ContainsKey("OrderByField")) {
                    $query = $query | Add-XrmQueryOrder -Field $OrderByField -OrderType $OrderType;
                }

                $sourceRecords = @($SourceXrmClient | Get-XrmMultipleRecords -Query $query);
                $readCount = $sourceRecords.Count;

                $passCount = 1;
                if ($TwoPassDependencies) {
                    $passCount = 2;
                }

                for ($passIndex = 1; $passIndex -le $passCount; $passIndex++) {
                    $includeEntityReferencesForPass = $IncludeEntityReferences;
                    if ($TwoPassDependencies) {
                        if ($passIndex -eq 1) {
                            $includeEntityReferencesForPass = $false;
                        }
                        else {
                            $includeEntityReferencesForPass = $true;
                        }
                    }

                    ForEach-ObjectWithProgress -Collection $sourceRecords -OperationName "Sync $logicalName (pass $passIndex/$passCount)" -ScriptBlock {
                        param($sourceRecord)

                        try {
                            $sourceEntity = $sourceRecord.Record;
                            $stateCodeValue = $null;
                            $statusCodeValue = $null;

                            $attributes = @{};
                            foreach ($sourceAttribute in $sourceEntity.Attributes.GetEnumerator()) {
                                $attributeName = [string]$sourceAttribute.Key;
                                $attributeValue = $sourceAttribute.Value;

                                if ($ExcludedAttributes -contains $attributeName) {
                                    continue;
                                }

                                if ($attributeName -eq "statecode") {
                                    if ($attributeValue) {
                                        $stateCodeValue = $attributeValue.Value;
                                    }
                                    continue;
                                }

                                if ($attributeName -eq "statuscode") {
                                    if ($attributeValue) {
                                        $statusCodeValue = $attributeValue.Value;
                                    }
                                    continue;
                                }

                                if ($attributeName -eq "createdon") {
                                    if ($PreserveCreatedOn -and $hasOverriddenCreatedOn) {
                                        if ($updatableAttributeSet.Contains("overriddencreatedon")) {
                                            $attributes["overriddencreatedon"] = $attributeValue;
                                        }
                                    }
                                    continue;
                                }

                                if ($attributeValue -is [Microsoft.Xrm.Sdk.EntityReference] -and -not $includeEntityReferencesForPass) {
                                    continue;
                                }

                                if (-not $targetAttributeSet.Contains($attributeName)) {
                                    continue;
                                }

                                if (-not $updatableAttributeSet.Contains($attributeName)) {
                                    continue;
                                }

                                $attributes[$attributeName] = $attributeValue;
                            }

                            $targetRecord = New-XrmEntity -LogicalName $logicalName -Id $sourceEntity.Id -Attributes $attributes;
                            $TargetXrmClient | Upsert-XrmRecord -Record $targetRecord -BypassCustomPluginExecution:$BypassCustomPluginExecution | Out-Null;

                            if ($passIndex -eq $passCount) {
                                $upsertedCount++;
                            }

                            if ($passIndex -eq $passCount -and $StateHandling -ne "Ignore" -and $hasStateCode) {
                                if ($StateHandling -eq "ApplyStateCode") {
                                    if ($null -ne $stateCodeValue) {
                                        $stateRecord = New-XrmEntity -LogicalName $logicalName -Id $sourceEntity.Id -Attributes @{
                                            "statecode" = New-XrmOptionSetValue -Value $stateCodeValue;
                                        };

                                        if ($hasStatusCode -and $null -ne $statusCodeValue) {
                                            $stateRecord.Attributes["statuscode"] = New-XrmOptionSetValue -Value $statusCodeValue;
                                        }

                                        $TargetXrmClient | Update-XrmRecord -Record $stateRecord | Out-Null;
                                    }
                                }
                                elseif ($StateHandling -eq "ApplyStateAndStatus") {
                                    if ($null -ne $stateCodeValue -and $null -ne $statusCodeValue -and $hasStatusCode) {
                                        $recordReference = New-XrmEntityReference -LogicalName $logicalName -Id $sourceEntity.Id;
                                        $TargetXrmClient | Set-XrmRecordState -RecordReference $recordReference -StateCode $stateCodeValue -StatusCode $statusCodeValue | Out-Null;
                                    }
                                }
                            }
                        }
                        catch {
                            $failedCount++;
                            $errorMessages.Add($_.Exception.Message) | Out-Null;
                            if (-not $ContinueOnError) {
                                throw $_.Exception;
                            }
                        }
                    };
                }
            }
            catch {
                $failedCount++;
                $errorMessages.Add($_.Exception.Message) | Out-Null;
                if (-not $ContinueOnError) {
                    throw $_.Exception;
                }
            }
            finally {
                $entityStopWatch.Stop();
                $summaryItem = [pscustomobject]@{
                    "LogicalName"   = $logicalName;
                    "ReadCount"     = $readCount;
                    "UpsertedCount" = $upsertedCount;
                    "FailedCount"   = $failedCount;
                    "Duration"      = $entityStopWatch.Elapsed;
                    "Errors"        = @($errorMessages);
                };
                $summary.Add($summaryItem) | Out-Null;
            }
        };

        $summary;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Sync-XrmRecords -Alias *;

Register-ArgumentCompleter -CommandName Sync-XrmRecords -ParameterName "LogicalNames" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
