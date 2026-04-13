<#
    .SYNOPSIS
    Disassociate records in Dataverse.

    .Description
    Remove a link between 1 row (Entity record) and multiple rows in Microsoft Dataverse.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Record
    Row / Record to split. (Entity)

    .PARAMETER RecordReferences
    Rows / Records references to split to Record. (EntityReference array)

    .PARAMETER RelationShipName
    RelationShip Logical name involve between these records.

    .PARAMETER IgnoreExistings
    Prevent exceptions if record associations doesn't exist.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $record = Get-XrmRecord -LogicalName "account" -Id $accountId;
    $contactRefs = @(New-XrmEntityReference -LogicalName "contact" -Id $contactId);
    Split-XrmRecords -Record $record -RecordReferences $contactRefs -RelationShipName "contact_customer_accounts";
#>
function Split-XrmRecords {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (    
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RecordReference,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference[]]
        $RecordReferences,

        [Parameter(Mandatory = $true)]
        [string]
        $RelationShipName,        

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.EntityRole]
        $RelationShipRole = [Microsoft.Xrm.Sdk.EntityRole]::Referencing
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {

        $relationShip = New-Object -TypeName "Microsoft.Xrm.Sdk.Relationship" -ArgumentList $RelationShipName;
        $relationShip.PrimaryEntityRole = $RelationShipRole;
        
        $recordReferenceCollection = New-Object -TypeName "Microsoft.Xrm.Sdk.EntityReferenceCollection";
        $RecordReferences | ForEach-Object {
            $recordReferenceCollection.Add($_);
        }
        
        $XrmClient.Disassociate($RecordReference.LogicalName, $RecordReference.Id, $relationShip, $recordReferenceCollection);        
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Split-XrmRecords -Alias *;