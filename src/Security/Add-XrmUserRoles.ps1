<#
    .SYNOPSIS
    Add security roles to user.

    .DESCRIPTION
    Assign on or multiple roles to given user.

    .PARAMETER UserId
    System user unique identifier.
    
    .PARAMETER Roles
    Roles unique identifier array to add.
#>
function Add-XrmUserRoles {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $UserId,

        [Parameter(Mandatory = $true)]
        [Guid[]]
        $Roles = @()
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        $relationShip = New-Object -TypeName "Microsoft.Xrm.Sdk.Relationship" -ArgumentList "systemuserroles_association";
        $roleReferences = New-Object -TypeName "Microsoft.Xrm.Sdk.EntityReferenceCollection";
        $Roles | ForEach-Object {
            $roleReference = New-XrmEntityReference -LogicalName "role" -Id $_;
            $roleReferences.Add($roleReference);
        }
        try {
            $XrmClient.Associate("systemuser", $UserId, $relationShip, $roleReferences);
        }
        catch {
            if (-not $_.Exception.Message.Contains("Cannot insert duplicate key")) {
                throw $_.Exception;
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Add-XrmUserRoles -Alias *;