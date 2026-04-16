<#
    .SYNOPSIS
    Create a new model-driven app in Microsoft Dataverse.

    .DESCRIPTION
    Create a new appmodule record (model-driven app) with the specified name and properties.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Display name for the app.

    .PARAMETER UniqueName
    Unique name for the app (auto-prefixed with publisher prefix).

    .PARAMETER Description
    App description. Optional.

    .PARAMETER WebResourceId
    Id of the web resource to use as app icon. Optional. Defaults to system default icon.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the app to. Optional.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created appmodule record.

    .EXAMPLE
    $appRef = New-XrmAppModule -Name "My Custom App" -UniqueName "myapp";
    $appRef = New-XrmAppModule -Name "My App" -UniqueName "myapp" -SolutionUniqueName "MySolution";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code
#>
function New-XrmAppModule {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $UniqueName,

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $false)]
        [Guid]
        $WebResourceId,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "appmodule" -Attributes @{
            "name"       = $Name;
            "uniquename" = $UniqueName;
        };

        if ($PSBoundParameters.ContainsKey('Description')) {
            $record["description"] = $Description;
        }
        if ($PSBoundParameters.ContainsKey('WebResourceId')) {
            $record["webresourceid"] = $WebResourceId;
        }

        $record.Id = $XrmClient | Add-XrmRecord -Record $record;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -SolutionUniqueName $SolutionUniqueName -ComponentId $record.Id -ComponentType 80;
        }

        $record.ToEntityReference();
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmAppModule -Alias *;
