<#
    .SYNOPSIS
    Update a form in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing systemform record.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER FormReference
    EntityReference of the systemform to update.

    .PARAMETER Name
    Updated form display name.

    .PARAMETER FormXml
    Updated form XML definition.

    .PARAMETER Description
    Updated description.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the updated systemform record.

    .EXAMPLE
    Set-XrmForm -FormReference $formRef -Name "Updated Main Form" -FormXml $newXml;
#>
function Set-XrmForm {
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
        $FormReference,

        [Parameter(Mandatory = $false)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [string]
        $FormXml,

        [Parameter(Mandatory = $false)]
        [string]
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "systemform" -Id $FormReference.Id;

        if ($PSBoundParameters.ContainsKey('Name')) {
            $record.Attributes["name"] = $Name;
        }
        if ($PSBoundParameters.ContainsKey('FormXml')) {
            $record.Attributes["formxml"] = $FormXml;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $record.Attributes["description"] = $Description;
        }

        Update-XrmRecord -XrmClient $XrmClient -Record $record;
        $FormReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmForm -Alias *;
