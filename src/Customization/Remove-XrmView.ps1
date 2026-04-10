<#
    .SYNOPSIS
    Delete a view from Microsoft Dataverse.

    .DESCRIPTION
    Delete a savedquery record (system view).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ViewReference
    EntityReference of the savedquery to delete.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Remove-XrmView -ViewReference $viewRef;
#>
function Remove-XrmView {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $ViewReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        Remove-XrmRecord -XrmClient $XrmClient -LogicalName "savedquery" -Id $ViewReference.Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmView -Alias *;
