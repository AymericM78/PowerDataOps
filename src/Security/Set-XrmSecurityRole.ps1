<#
    .SYNOPSIS
    Update a security role.

    .DESCRIPTION
    Update an existing security role (role) record in Microsoft Dataverse.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RoleReference
    Entity reference of the security role to update.

    .PARAMETER Name
    New display name for the security role.

    .PARAMETER Description
    New description for the security role.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the updated role record.

    .EXAMPLE
    $roleRef = New-XrmEntityReference -LogicalName "role" -Id $roleId;
    Set-XrmSecurityRole -RoleReference $roleRef -Name "Updated Role Name";
#>
function Set-XrmSecurityRole {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RoleReference,

        [Parameter(Mandatory = $false)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [string]
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "role" -Id $RoleReference.Id;

        if ($PSBoundParameters.ContainsKey('Name')) {
            $record.Attributes["name"] = $Name;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $record.Attributes["description"] = $Description;
        }

        Update-XrmRecord -XrmClient $XrmClient -Record $record;
        $RoleReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmSecurityRole -Alias *;
