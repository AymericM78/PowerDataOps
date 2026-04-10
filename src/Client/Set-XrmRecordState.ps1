<#
    .SYNOPSIS
    Set the state and status of a record.

    .DESCRIPTION
    Update the statecode and statuscode of a Dataverse record using Update-XrmRecord.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RecordReference
    Entity reference of the target record.

    .PARAMETER StateCode
    State code value to set (e.g., 0 = Active, 1 = Inactive).

    .PARAMETER StatusCode
    Status code value to set. Must be valid for the given state code.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $accountRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
    Set-XrmRecordState -XrmClient $xrmClient -RecordReference $accountRef -StateCode 1 -StatusCode 2;
#>
function Set-XrmRecordState {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RecordReference,

        [Parameter(Mandatory = $true)]
        [int]
        $StateCode,

        [Parameter(Mandatory = $true)]
        [int]
        $StatusCode
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $record = New-XrmEntity -LogicalName $RecordReference.LogicalName -Id $RecordReference.Id;
        $record.Attributes["statecode"] = New-XrmOptionSetValue -Value $StateCode;
        $record.Attributes["statuscode"] = New-XrmOptionSetValue -Value $StatusCode;

        Update-XrmRecord -XrmClient $XrmClient -Record $record;
        $RecordReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmRecordState -Alias *;
