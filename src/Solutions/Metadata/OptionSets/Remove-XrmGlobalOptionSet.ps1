<#
    .SYNOPSIS
    Delete a global option set from Microsoft Dataverse.

    .DESCRIPTION
    Delete a global option set using DeleteOptionSetRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Global option set name to delete.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteOptionSet response.

    .EXAMPLE
    Remove-XrmGlobalOptionSet -Name "new_priority";
#>
function Remove-XrmGlobalOptionSet {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.DeleteOptionSetRequest]::new();
        $request.Name = $Name;

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmGlobalOptionSet -Alias *;
