<#
    .SYNOPSIS
    Delete a connection role from Microsoft Dataverse.

    .DESCRIPTION
    Remove a connectionrole record.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ConnectionRoleReference
    EntityReference of the connectionrole record to delete.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $roleRef = New-XrmEntityReference -LogicalName "connectionrole" -Id $roleId;
    Remove-XrmConnectionRole -ConnectionRoleReference $roleRef;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/describe-relationship-entities-connection-roles
#>
function Remove-XrmConnectionRole {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $ConnectionRoleReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "connectionrole";
        $record.Id = $ConnectionRoleReference.Id;

        $XrmClient | Remove-XrmRecord -Record $record;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmConnectionRole -Alias *;
