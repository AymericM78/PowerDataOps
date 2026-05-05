<#
    .SYNOPSIS
    Remove security roles from a model-driven app.

    .DESCRIPTION
    Revoke access to a model-driven app for one or more security roles by removing
    the association via the appmoduleroles_association N:N relationship.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleReference
    Reference to the appmodule record.

    .PARAMETER RoleReferences
    Array of EntityReference objects pointing to the security roles to remove.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $appRef = Get-XrmAppModules -Name "My App" | Select-Object -First 1 | ForEach-Object { $_.Reference };
    $role = Get-XrmRoles -Name "Sales Manager" | Select-Object -First 1;
    Remove-XrmAppModuleRoles -AppModuleReference $appRef -RoleReferences @($role.Reference);

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/appmodule?view=dataverse-latest
#>
function Remove-XrmAppModuleRoles {
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
        $XrmClient | Split-XrmRecords -RecordReference $AppModuleReference -RecordReferences $RoleReferences -RelationShipName "appmoduleroles_association";
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmAppModuleRoles -Alias *;
