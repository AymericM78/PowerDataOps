<#
    .SYNOPSIS
    Delete a command bar button from Microsoft Dataverse.

    .DESCRIPTION
    Delete an appaction record (command bar button).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER CommandReference
    EntityReference of the appaction to delete.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Remove-XrmCommand -CommandReference $cmdRef;
#>
function Remove-XrmCommand {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $CommandReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        Remove-XrmRecord -XrmClient $XrmClient -LogicalName "appaction" -Id $CommandReference.Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmCommand -Alias *;
