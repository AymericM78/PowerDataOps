<#
    .SYNOPSIS
    Associate records in Dataverse.

    .Description
    Add a link between 1 row (Entity record) and multiple rows in Microsoft Dataverse.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Record
    Row / Record to join. (Entity)

    .PARAMETER RecordReferences
    Rows / Records references to link to Record. (EntityReference array)

    .PARAMETER RelationShipName
    RelationShip Logical name involve between these records.

    .PARAMETER IgnoreExistings
    Prevent exceptions if record associations already exist (error => Cannot insert duplicate key).
#>
function Join-XrmRecords {
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
        [Microsoft.Xrm.Sdk.EntityReference[]]
        $RecordReferences,

        [Parameter(Mandatory = $true)]
        [string]
        $RelationShipName,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.EntityRole]
        $RelationShipRole = [Microsoft.Xrm.Sdk.EntityRole]::Referencing,

        [Parameter(Mandatory = $false)]
        [bool]
        $IgnoreExistings = $true        
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

        try {
            $XrmClient.Associate($RecordReference.LogicalName, $RecordReference.Id, $relationShip, $recordReferenceCollection);
        }
        catch {
            if ($IgnoreExistings -and $_.Exception.Message.Contains("Cannot insert duplicate key")) {
                return;
            }
            else {
                throw $_.Exception;
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Join-XrmRecords -Alias *;