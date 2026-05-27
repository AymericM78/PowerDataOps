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

    .PARAMETER Labels
    Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). -Name takes precedence if both are provided.

    .PARAMETER LanguageCode
    Language code used to pick the stored 'name' from -Labels. Default: 1033.

    .PARAMETER FormXml
    Updated form XML definition.

    .PARAMETER Description
    Updated description.

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the updated form is automatically added to this solution.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the updated systemform record.

    .EXAMPLE
    Set-XrmForm -FormReference $formRef -Name "Updated Main Form" -FormXml $newXml;
    Set-XrmForm -FormReference $formRef -FormXml $newXml -SolutionUniqueName "MySolution";
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
        [Hashtable]
        $Labels,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033,

        [Parameter(Mandatory = $false)]
        [string]
        $FormXml,

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
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
        elseif ($PSBoundParameters.ContainsKey('Labels')) {
            $record.Attributes["name"] = Get-XrmLabelText -Labels $Labels -LanguageCode $LanguageCode;
        }
        if ($PSBoundParameters.ContainsKey('FormXml')) {
            $record.Attributes["formxml"] = $FormXml;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $record.Attributes["description"] = $Description;
        }

        Update-XrmRecord -XrmClient $XrmClient -Record $record;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $FormReference.Id -ComponentType 60 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        $FormReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmForm -Alias *;
