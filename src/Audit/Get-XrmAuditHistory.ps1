<#
    .SYNOPSIS
    Retrieve audit for given record.
    
    .DESCRIPTION
    Get record audit history for given fields changes

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER RecordReference
    Lookup to target record. (EntityReference)

    .PARAMETER AttributeFilter
    Attributes logical names to filter.
#>
function Get-XrmAuditHistory {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RecordReference,

        [Parameter(Mandatory = $false)]
        [String[]]
        $AttributeFilter
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $auditLogs = @();

        $retrieveRecordChangeHistoryRequest = New-Object -TypeName Microsoft.Crm.Sdk.Messages.RetrieveRecordChangeHistoryRequest;
        $retrieveRecordChangeHistoryRequest.Target = $RecordReference;
        $retrieveRecordChangeHistoryReponse = Protect-XrmCommand -ScriptBlock { $XrmClient.Execute($retrieveRecordChangeHistoryRequest) };

        foreach ($auditDetail in $retrieveRecordChangeHistoryReponse.AuditDetailCollection.AuditDetails) {
            $attributes = @();
            $auditDetail.NewValue.Attributes | ForEach-Object { $attributes += $_.Key; };
            $auditDetail.OldValue.Attributes | ForEach-Object { if (-not $attributes.Contains($_.Key)) { $attributes += $_.Key; } };
            
            foreach ($attributeName in $attributes) {

                if ($null -eq $attributeName) {
                    # Weird case : sometimes $attributes collection contains only 1 $null value                    
                    continue;
                }

                if ($AttributeFilter -and ($AttributeFilter.Contains($attributeName) -eq $false)) {
                    continue;
                }

                $auditRecord = $auditDetail.AuditRecord;

                $hash = @{};
                $hash["Object"] = $auditRecord.FormattedValues["objecttypecode"];
                $hash["Id"] = $auditRecord.Id;
                $hash["ObjectId"] = $auditRecord["objectid"].Id;
                $hash["Key"] = $RecordReference.Id;
                $hash["AttributeName"] = $attributeName;
                $hash["CreatedOn"] = $auditRecord.FormattedValues["createdon"];
                $hash["User"] = $auditRecord["userid"].Name;
                $hash["Operation"] = $auditRecord.FormattedValues["operation"];
                $hash["Action"] = $auditRecord.FormattedValues["action"];
                $hash["OldValue"] = $null;
                if ($auditDetail.OldValue) {
                    $hash["OldValue"] = $auditDetail.OldValue | Get-XrmAttributeValue -Name $attributeName -FormattedValue;
                }
                $hash["NewValue"] = $null;
                if ($auditDetail.NewValue) {
                    $hash["NewValue"] = $auditDetail.NewValue | Get-XrmAttributeValue -Name $attributeName -FormattedValue;
                }
                
                $auditLog = New-Object PsObject -Property $hash;
                $auditLogs += $auditLog;
            }
        }
        $auditLogs;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmAuditHistory -Alias *;