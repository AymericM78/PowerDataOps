<#
    .SYNOPSIS
    Assign security roles to a model-driven app.

    .DESCRIPTION
    Grant one or more security roles access to a model-driven app via the
    appmoduleroles_association N:N relationship. Users must belong to one of the
    assigned roles to see the app in the app picker.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleReference
    Reference to the appmodule record.

    .PARAMETER RoleReferences
    Array of EntityReference objects pointing to the security roles to assign.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $appRef = Get-XrmAppModules -Name "My App" | Select-Object -First 1 | ForEach-Object { $_.Reference };
    $role = Get-XrmRoles -Name "Sales Manager" | Select-Object -First 1;
    Add-XrmAppModuleRoles -AppModuleReference $appRef -RoleReferences @($role.Reference);

    .EXAMPLE
    $roleRefs = Get-XrmRoles | Where-Object { $_.name -like "Sales*" } | ForEach-Object { $_.Reference };
    Add-XrmAppModuleRoles -AppModuleReference $appRef -RoleReferences $roleRefs;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/appmodule?view=dataverse-latest
#>
function Add-XrmAppModuleRoles {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $AppModuleReference,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference[]]
        $RoleReferences
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $XrmClient | Join-XrmRecords -RecordReference $AppModuleReference -RecordReferences $RoleReferences -RelationShipName "appmoduleroles_association";
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmAppModuleRoles -Alias *;
