<#
    .SYNOPSIS
    Delete a model-driven app from Microsoft Dataverse.

    .DESCRIPTION
    Remove an appmodule record (model-driven app).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleReference
    EntityReference of the appmodule record to delete.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Remove-XrmAppModule -AppModuleReference $appRef;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code
#>
function Remove-XrmAppModule {
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
        $AppModuleReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $XrmClient | Remove-XrmRecord -Record (New-XrmEntity -LogicalName "appmodule" -Attributes @{ "appmoduleid" = $AppModuleReference.Id });
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmAppModule -Alias *;
