<#
    .SYNOPSIS
    Delete a form from Microsoft Dataverse.

    .DESCRIPTION
    Delete a systemform record.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER FormReference
    EntityReference of the systemform to delete.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Remove-XrmForm -FormReference $formRef;
#>
function Remove-XrmForm {
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
        $FormReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        Remove-XrmRecord -XrmClient $XrmClient -LogicalName "systemform" -Id $FormReference.Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmForm -Alias *;
