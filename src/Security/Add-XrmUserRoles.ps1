<#
    .SYNOPSIS
    Add security roles to user.

    .DESCRIPTION
    Assign one or multiple roles to given user.

    .PARAMETER UserId
    System user unique identifier.
    
    .PARAMETER Roles
    Roles unique identifier array to add.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Add-XrmUserRoles -UserId $userId -Roles @($roleId1, $roleId2);
#>
function Add-XrmUserRoles {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $UserReference,

        [Parameter(Mandatory = $true)]
        [Guid[]]
        $Roles = @()
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        $roleReferences = New-Object -TypeName "Microsoft.Xrm.Sdk.EntityReferenceCollection";
        $Roles | ForEach-Object {
            $roleReference = New-XrmEntityReference -LogicalName "role" -Id $_;
            $roleReferences.Add($roleReference);
        }
        Join-XrmRecords -XrmClient $XrmClient -RecordReference $UserReference -RecordReferences $roleReferences  -RelationShipName "systemuserroles_association";
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Add-XrmUserRoles -Alias *;