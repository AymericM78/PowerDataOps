<#
    .SYNOPSIS
    Apply a business process flow stage to a record.

    .DESCRIPTION
    Set or create a BPF instance for a target record at a specified stage. If a BPF record already exists, 
    updates the active stage and traversed path. Otherwise, creates a new BPF instance.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER TargetRecordReference
    Entity reference of the target record bound to the BPF.

    .PARAMETER TargetStageName
    Name of the BPF stage to apply.

    .PARAMETER BpfEntityLogicalName
    Logical name of the BPF entity (e.g., "leadtoopportunitysalesprocess").

    .PARAMETER BpfLookupAttributeName
    Logical name of the BPF lookup attribute that references the target record.

    .PARAMETER ProcessId
    Business process flow unique identifier (workflow id).

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $caseRef = New-XrmEntityReference -LogicalName "incident" -Id $caseId;
    Apply-XrmBusinessProcessFlowStage -XrmClient $xrmClient -TargetRecordReference $caseRef -TargetStageName "Qualify" -BpfEntityLogicalName "df_casebpf" -BpfLookupAttributeName "bpf_df_caseid" -ProcessId $processId;
#>
function Apply-XrmBusinessProcessFlowStage {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $TargetRecordReference,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $TargetStageName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $BpfEntityLogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $BpfLookupAttributeName,

        [Parameter(Mandatory = $true)]
        [Guid]
        $ProcessId
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $targetStage = Get-XrmBusinessProcessFlowStage -XrmClient $XrmClient -StageName $TargetStageName -ProcessId $ProcessId;

        $processRecord = Get-XrmRecord -XrmClient $XrmClient -LogicalName $BpfEntityLogicalName -AttributeName $BpfLookupAttributeName -Value $TargetRecordReference.Id -Columns "activestageid", "traversedpath";
        if ($processRecord) {
            $traversedPath = "$($processRecord.traversedpath),$($targetStage.Id)";

            $processRecordUpdate = New-XrmEntity -LogicalName $BpfEntityLogicalName -Id $processRecord.Id -Attributes @{
                "activestageid" = $targetStage.Reference
                "traversedpath" = $traversedPath
            };
            Update-XrmRecord -XrmClient $XrmClient -Record $processRecordUpdate;
        }
        else {
            $newProcessRecord = New-XrmEntity -LogicalName $BpfEntityLogicalName -Attributes @{
                $BpfLookupAttributeName = $TargetRecordReference
                "activestageid"         = $targetStage.Reference
                "traversedpath"         = "$($targetStage.Id)"
            };
            Add-XrmRecord -XrmClient $XrmClient -Record $newProcessRecord | Out-Null;
        };
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Apply-XrmBusinessProcessFlowStage -Alias *;
