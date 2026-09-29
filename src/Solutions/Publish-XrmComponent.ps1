<#
    .SYNOPSIS
    Publish a specific Dataverse component using a targeted PublishXml request.

    .DESCRIPTION
    Publish one or several components of the same type (app module, entity, option set, web resource, ribbon, etc.)
    without triggering a full Publish-XrmCustomizations. Builds the required
    <importexportxml> payload from the component name and identifiers: one request for all of them.

    Use this instead of Publish-XrmCustomizations when you want to target a few
    components and avoid the overhead of a full publish cycle.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ComponentName
    XML element name of the component type to publish.
    Common values: appmodule, entity, optionset, webresource, ribbon, sitemap, workflow.

    .PARAMETER ComponentId
    Identifiers of the components: GUID strings for record-based components (appmodule,
    webresource), logical names for schema-based components (entity, optionset, ribbon).

    .PARAMETER TimeoutInMinutes
    Maximum wait for the publish, which is synchronous. The request is sent through a clone of the connection created with this timeout (a ServiceClient keeps the timeout it was created with). (Default: the timeout of the connection)

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. Response from the PublishXml request.

    .EXAMPLE
    # Publish a model-driven app
    Publish-XrmComponent -ComponentName "appmodule" -ComponentId "3d9e2f1a-...";

    .EXAMPLE
    # Publish a single entity's customizations
    Publish-XrmComponent -ComponentName "entity" -ComponentId "account";

    .EXAMPLE
    # Publish several apps in one request, allowing 20 minutes
    Publish-XrmComponent -XrmClient $xrmClient -ComponentName "appmodule" -ComponentId $salesApp.Id, $serviceApp.Id -TimeoutInMinutes 20;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Publish-XrmComponent.md
#>
function Publish-XrmComponent {
    [CmdletBinding(SupportsShouldProcess)]
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
        [string[]]
        $ComponentId,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 1440)]
        [int]
        $TimeoutInMinutes
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $elements = ($ComponentId | ForEach-Object { "<${ComponentName}>$_</${ComponentName}>" }) -join "";
        $xml = "<importexportxml><${ComponentName}s>$elements</${ComponentName}s></importexportxml>";
        $request = New-XrmRequest -Name "PublishXml";
        $request | Add-XrmRequestParameter -Name "ParameterXml" -Value $xml | Out-Null;

        if (-not $PSBoundParameters.ContainsKey('TimeoutInMinutes')) {
            return ($XrmClient | Invoke-XrmRequest -Request $request);
        }

        # The timeout of a ServiceClient is fixed when it connects: a clone made after raising the
        # static MaxConnectionTimeout gets the longer one, the caller's client keeps its own
        $previousTimeout = [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]::MaxConnectionTimeout;
        $publishClient = $null;
        try {
            [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]::MaxConnectionTimeout = [TimeSpan]::FromMinutes($TimeoutInMinutes);
            $publishClient = $XrmClient.Clone();
            Invoke-XrmRequest -XrmClient $publishClient -Request $request;
        }
        finally {
            [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]::MaxConnectionTimeout = $previousTimeout;
            if ($publishClient) {
                $publishClient.Dispose();
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Publish-XrmComponent -Alias *;
