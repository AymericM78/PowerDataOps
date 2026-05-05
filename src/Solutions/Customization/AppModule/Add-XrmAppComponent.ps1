<#
    .SYNOPSIS
    Add components to a model-driven app.

    .DESCRIPTION
    Add one or more components (tables, forms, views, dashboards, BPF, sitemap, etc.) to an existing model-driven app using the AddAppComponents SDK action.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleId
    Guid of the appmodule to add components to.

    .PARAMETER ComponentId
    Guid of the component to add.

    .PARAMETER ComponentEntityLogicalName
    Entity type name of the component (e.g. savedquery, systemform, sitemap, workflow, entity).

    .PARAMETER ComponentIdAttributeName
    Primary key attribute name of the component entity (e.g. savedqueryid, formid, sitemapid). Optional — auto-resolved from ComponentEntityLogicalName when possible.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The AddAppComponents response.

    .EXAMPLE
    Add-XrmAppComponent -AppModuleId $appId -ComponentId $viewId -ComponentEntityLogicalName "savedquery";
    Add-XrmAppComponent -AppModuleId $appId -ComponentId $formId -ComponentEntityLogicalName "systemform";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/addappcomponents
#>
function Add-XrmAppComponent {
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
        $ComponentEntityLogicalName,

        [Parameter(Mandatory = $false)]
        [string]
        $ComponentIdAttributeName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        # Resolve primary key attribute name if not provided
        if (-not $PSBoundParameters.ContainsKey('ComponentIdAttributeName')) {
            $idAttributeMap = @{
                "savedquery"  = "savedqueryid";
                "systemform"  = "formid";
                "sitemap"     = "sitemapid";
                "workflow"    = "workflowid";
                "entity"      = "entityid";
                "appaction"   = "appactionid";
                "webresource" = "webresourceid";
            };
            $ComponentIdAttributeName = $idAttributeMap[$ComponentEntityLogicalName];
            if (-not $ComponentIdAttributeName) {
                $ComponentIdAttributeName = "$($ComponentEntityLogicalName)id";
            }
        }

        $componentEntity = New-XrmEntity -LogicalName $ComponentEntityLogicalName;
        $componentEntity[$ComponentIdAttributeName] = $ComponentId;

        $entityCollection = New-XrmEntityCollection -Entities @($componentEntity);

        $request = New-XrmRequest -Name "AddAppComponents";
        $request | Add-XrmRequestParameter -Name "AppId" -Value $AppModuleId | Out-Null;
        $request | Add-XrmRequestParameter -Name "Components" -Value $entityCollection | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmAppComponent -Alias *;
