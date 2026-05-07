<#
    .SYNOPSIS
    Remove components from a model-driven app.

    .DESCRIPTION
    Remove one or more components from an existing model-driven app using the RemoveAppComponents SDK action.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleId
    Guid of the appmodule to remove components from.

    .PARAMETER ComponentId
    Guid of the component to remove.

    .PARAMETER ComponentEntityLogicalName
    Entity type name of the component (e.g. savedquery, systemform, sitemap, workflow, entity).

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The RemoveAppComponents response.

    .EXAMPLE
    Remove-XrmAppComponent -AppModuleId $appId -ComponentId $viewId -ComponentEntityLogicalName "savedquery";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/removeappcomponents
#>
function Remove-XrmAppComponent {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $AppModuleId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $ComponentId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ComponentEntityLogicalName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $componentRef = New-XrmEntityReference -LogicalName $ComponentEntityLogicalName -Id $ComponentId;
        $components = New-XrmEntityReferenceCollection -EntityReferences @($componentRef);

        $request = New-XrmRequest -Name "RemoveAppComponents";
        $request | Add-XrmRequestParameter -Name "AppId" -Value $AppModuleId | Out-Null;
        $request | Add-XrmRequestParameter -Name "Components" -Value $components | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmAppComponent -Alias *;
