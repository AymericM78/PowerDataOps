<#
    .SYNOPSIS
    Remove user from a team.

    .DESCRIPTION
    Disassociate a system user from a specified team using the teammembership_association relationship.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER TeamReference
    Team entity reference.

    .PARAMETER UserReferences
    Array of system user entity references to remove from the team.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $teamRef = New-XrmEntityReference -LogicalName "team" -Id $teamId;
    $userRef1 = New-XrmEntityReference -LogicalName "systemuser" -Id $userId1;
    $userRef2 = New-XrmEntityReference -LogicalName "systemuser" -Id $userId2;
    Remove-XrmUserFromTeam -XrmClient $xrmClient -TeamReference $teamRef -UserReferences @($userRef1, $userRef2);
#>
function Remove-XrmUserFromTeam {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $TeamReference,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference[]]
        $UserReferences
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        $collection = New-Object -TypeName "Microsoft.Xrm.Sdk.EntityReferenceCollection";
        $UserReferences | ForEach-Object {
            $collection.Add($_);
        };
        Split-XrmRecords -XrmClient $XrmClient -RecordReference $TeamReference -RecordReferences $collection -RelationShipName "teammembership_association";
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Remove-XrmUserFromTeam -Alias *;
