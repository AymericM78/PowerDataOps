<#
    .SYNOPSIS
    Remove multiple components from a model-driven app in a single SDK call.

    .DESCRIPTION
    Remove a batch of components from an existing model-driven app using a single RemoveAppComponents request.
    More efficient than calling Remove-XrmAppComponent in a loop because all references are sent in one request.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleId
    Guid of the appmodule to remove components from.

    .PARAMETER Components
    Collection of components to remove. Supported input shapes:
    - [Microsoft.Xrm.Sdk.EntityReference]
    - @{ ComponentId = <Guid>; ComponentEntityLogicalName = <string> }
    - PSCustomObject with ComponentId / ComponentEntityLogicalName (or Id / LogicalName) properties

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The RemoveAppComponents response.

    .EXAMPLE
    $refs = @(
        (New-XrmEntityReference -LogicalName "savedquery" -Id $viewId),
        (New-XrmEntityReference -LogicalName "systemform" -Id $formId)
    );
    Remove-XrmAppComponents -AppModuleId $appId -Components $refs;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/removeappcomponents
#>
function Remove-XrmAppComponents {
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
        [Object[]]
        $Components
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $references = @();
        foreach ($component in $Components) {
            if ($component -is [Microsoft.Xrm.Sdk.EntityReference]) {
                $references += $component;
                continue;
            }

            $componentId = $null;
            $logicalName = $null;

            if ($component.PSObject.Properties.Match("ComponentId").Count -gt 0) {
                $componentId = $component.ComponentId;
            }
            elseif ($component.PSObject.Properties.Match("Id").Count -gt 0) {
                $componentId = $component.Id;
            }

            if ($component.PSObject.Properties.Match("ComponentEntityLogicalName").Count -gt 0) {
                $logicalName = $component.ComponentEntityLogicalName;
            }
            elseif ($component.PSObject.Properties.Match("LogicalName").Count -gt 0) {
                $logicalName = $component.LogicalName;
            }

            if (-not $componentId -or -not $logicalName) {
                throw "Invalid component descriptor: each component must provide ComponentId/Id and ComponentEntityLogicalName/LogicalName, or be an EntityReference.";
            }

            $references += (New-XrmEntityReference -LogicalName $logicalName -Id ([Guid]::Parse($componentId.ToString())));
        }

        if ($references.Count -eq 0) {
            return;
        }

        $collection = New-XrmEntityReferenceCollection -EntityReferences $references;

        $request = New-XrmRequest -Name "RemoveAppComponents";
        $request | Add-XrmRequestParameter -Name "AppId" -Value $AppModuleId | Out-Null;
        $request | Add-XrmRequestParameter -Name "Components" -Value $collection | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmAppComponents -Alias *;
