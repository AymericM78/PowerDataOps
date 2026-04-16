<#
    .SYNOPSIS
    Create a new security role.

    .DESCRIPTION
    Create a new security role (role) record in Microsoft Dataverse.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Security role display name.

    .PARAMETER BusinessUnitReference
    Business unit entity reference. Defaults to root business unit if not provided.

    .PARAMETER Description
    Security role description.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created role record.

    .EXAMPLE
    $roleRef = New-XrmSecurityRole -Name "Custom Role";

    .EXAMPLE
    $buRef = New-XrmEntityReference -LogicalName "businessunit" -Id $buId;
    $roleRef = New-XrmSecurityRole -Name "Custom Role" -BusinessUnitReference $buRef -Description "Custom role for testing";
#>
function New-XrmSecurityRole {
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
        $attributes = @{
            "name" = $Name;
        };

        if ($PSBoundParameters.ContainsKey('BusinessUnitReference')) {
            $attributes["businessunitid"] = $BusinessUnitReference;
        }
        else {
            $rootBU = Get-XrmRootBusinessUnit -XrmClient $XrmClient;
            $attributes["businessunitid"] = $rootBU.Reference;
        }

        $record = New-XrmEntity -LogicalName "role" -Attributes $attributes;

        if ($PSBoundParameters.ContainsKey('Description')) {
            $record.Attributes["description"] = $Description;
        }

        $record.Id = Add-XrmRecord -XrmClient $XrmClient -Record $record;
        $record.ToEntityReference();
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmSecurityRole -Alias *;
