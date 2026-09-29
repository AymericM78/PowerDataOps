<#
    .SYNOPSIS
    Retrieve components of a model-driven app.

    .DESCRIPTION
    Get all components included in a published model-driven app using the RetrieveAppComponents SDK function.
    RetrieveAppComponents fails on an app that was never published ("appmodule ... Does Not Exist"). With Unpublished, the components are read from the appmodulecomponent table instead, which holds them as soon as they are added.
    Web resources are never app components: the platform refuses to add them to an app.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleId
    Guid of the appmodule to retrieve components from.

    .PARAMETER Unpublished
    Read the components of the app in its current (unpublished) state from the appmodulecomponent table.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityCollection. Collection of app component records (componenttype, objectid).

    .EXAMPLE
    $components = Get-XrmAppComponents -AppModuleId $appId;

    .EXAMPLE
    # App being built, not published yet
    $components = Get-XrmAppComponents -XrmClient $xrmClient -AppModuleId $appId -Unpublished;
    $siteMaps = $components.Entities | Where-Object { $_["componenttype"].Value -eq 62 };

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/retrieveappcomponents
#>
function Get-XrmAppComponents {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityCollection])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $AppModuleId,

        [Parameter(Mandatory = $false)]
        [switch]
        $Unpublished
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($Unpublished) {
            # appmodulecomponent is linked to the app through appmoduleidunique, read on the unpublished app
            $appQuery = New-XrmQueryExpression -LogicalName "appmodule" -Columns "appmoduleidunique";
            $appQuery = $appQuery | Add-XrmQueryCondition -Field "appmoduleid" -Condition Equal -Values $AppModuleId;
            $app = $XrmClient | Get-XrmMultipleComponents -Query $appQuery -Unpublished | Select-Object -First 1;
            if (-not $app) {
                throw "App module '$AppModuleId' not found.";
            }

            $componentQuery = New-XrmQueryExpression -LogicalName "appmodulecomponent" -Columns "componenttype", "objectid";
            $componentQuery = $componentQuery | Add-XrmQueryCondition -Field "appmoduleidunique" -Condition Equal -Values ([Guid]$app.appmoduleidunique);
            $rows = @($XrmClient | Get-XrmMultipleRecords -Query $componentQuery);
            $collection = New-XrmEntityCollection -Entities @($rows | ForEach-Object { $_.Record });
            return , $collection;
        }

        $request = New-XrmRequest -Name "RetrieveAppComponents";
        $request | Add-XrmRequestParameter -Name "AppModuleId" -Value $AppModuleId | Out-Null;
        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response.Results["AppComponents"];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmAppComponents -Alias *;
