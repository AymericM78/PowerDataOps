<#
    .SYNOPSIS
    Delete a security role.

    .DESCRIPTION
    Delete a security role (role) record from Microsoft Dataverse.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RoleReference
    Entity reference of the security role to delete.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $roleRef = New-XrmEntityReference -LogicalName "role" -Id $roleId;
    Remove-XrmSecurityRole -RoleReference $roleRef;
#>
function Remove-XrmSecurityRole {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RoleReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        Remove-XrmRecord -XrmClient $XrmClient -LogicalName "role" -Id $RoleReference.Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmSecurityRole -Alias *;
