<#
    .SYNOPSIS
    Publish a specific Dataverse component using a targeted PublishXml request.

    .DESCRIPTION
    Publish one component (app module, entity, option set, web resource, ribbon, etc.)
    without triggering a full Publish-XrmCustomizations. Builds the required
    <importexportxml> payload from the component name and identifier.

    Use this instead of Publish-XrmCustomizations when you want to target a single
    component and avoid the overhead of a full publish cycle.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ComponentName
    XML element name of the component type to publish.
    Common values: appmodule, entity, optionset, webresource, ribbon, sitemap, workflow.

    .PARAMETER ComponentId
    Identifier of the component: GUID string for record-based components (appmodule,
    webresource), logical name for schema-based components (entity, optionset, ribbon).

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. Response from the PublishXml request.

    .EXAMPLE
    # Publish a model-driven app
    Publish-XrmComponent -ComponentName "appmodule" -ComponentId "3d9e2f1a-...";

    .EXAMPLE
    # Publish a single entity's customizations
    Publish-XrmComponent -ComponentName "entity" -ComponentId "account";

    .EXAMPLE
    # Publish a global option set
    Publish-XrmComponent -ComponentName "optionset" -ComponentId "my_status";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/publishxml?view=dataverse-latest
#>
function Publish-XrmComponent {
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
        $ComponentName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ComponentId
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $xml = "<importexportxml><${ComponentName}s><${ComponentName}>$ComponentId</${ComponentName}></${ComponentName}s></importexportxml>";

        $request = New-XrmRequest -Name "PublishXml";
        $request | Add-XrmRequestParameter -Name "ParameterXml" -Value $xml | Out-Null;

        Protect-XrmCommand -ScriptBlock { $XrmClient.Execute($request) };
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Publish-XrmComponent -Alias *;
