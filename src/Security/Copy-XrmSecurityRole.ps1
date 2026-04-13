<#
    .SYNOPSIS
    Copy a security role.

    .DESCRIPTION
    Clone an existing security role by creating a new role and copying all privileges from the source role using the ReplacePrivilegesRole SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SourceRoleReference
    Entity reference of the source security role to copy privileges from.

    .PARAMETER Name
    Display name for the new security role.

    .PARAMETER BusinessUnitReference
    Business unit entity reference for the new role. Defaults to root business unit if not provided.

    .PARAMETER Description
    Description for the new security role.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the newly created role record.

    .EXAMPLE
    $sourceRef = New-XrmEntityReference -LogicalName "role" -Id $existingRoleId;
    $newRoleRef = Copy-XrmSecurityRole -SourceRoleReference $sourceRef -Name "Copy of Sales Role";

    .EXAMPLE
    $buRef = New-XrmEntityReference -LogicalName "businessunit" -Id $buId;
    $newRoleRef = Copy-XrmSecurityRole -SourceRoleReference $sourceRef -Name "Cloned Role" -BusinessUnitReference $buRef;
#>
function Copy-XrmSecurityRole {
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
        $SourceRoleReference,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $BusinessUnitReference,

        [Parameter(Mandatory = $false)]
        [string]
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        # Step 1: Retrieve privileges from source role
        $sourcePrivileges = Get-XrmRolePrivileges -XrmClient $XrmClient -RoleId $SourceRoleReference.Id;

        # Step 2: Create the new role
        $newRoleParams = @{
            XrmClient = $XrmClient;
            Name      = $Name;
        };
        if ($PSBoundParameters.ContainsKey('BusinessUnitReference')) {
            $newRoleParams["BusinessUnitReference"] = $BusinessUnitReference;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $newRoleParams["Description"] = $Description;
        }
        $newRoleRef = New-XrmSecurityRole @newRoleParams;

        # Step 3: Copy privileges to the new role
        Set-XrmSecurityRolePrivileges -XrmClient $XrmClient -RoleReference $newRoleRef -Privileges $sourcePrivileges | Out-Null;

        $newRoleRef;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Copy-XrmSecurityRole -Alias *;
