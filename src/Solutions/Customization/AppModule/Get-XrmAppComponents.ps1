<#
    .SYNOPSIS
    Retrieve components of a model-driven app.

    .DESCRIPTION
    Get all components included in a published model-driven app using the RetrieveAppComponents SDK function.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleId
    Guid of the appmodule to retrieve components from.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityCollection. Collection of app component records.

    .EXAMPLE
    $components = Get-XrmAppComponents -AppModuleId $appId;

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
        $AppModuleId
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
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
