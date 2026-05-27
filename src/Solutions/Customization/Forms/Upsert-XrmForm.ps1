<#
    .SYNOPSIS
    Create or update a form in Microsoft Dataverse.

    .DESCRIPTION
    Upsert a systemform record by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Id
    Form (systemform) Id used as the upsert key.

    .PARAMETER EntityLogicalName
    Table / Entity logical name the form belongs to. Optional for dashboards.

    .PARAMETER Name
    Form display name.

    .PARAMETER Labels
    Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). Example: @{ 1033 = "Main Form"; 1036 = "Formulaire principal" }

    .PARAMETER LanguageCode
    Language code used to pick the stored 'name' from -Labels. Default: 1033.

    .PARAMETER FormXml
    Form XML definition.

    .PARAMETER FormType
    Form type (0=Dashboard, 2=Main, 5=Mobile, 6=QuickCreate, 7=QuickView).

    .PARAMETER Description
    Form description.

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the form is added to this solution.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted systemform record.

    .EXAMPLE
    $ref = Upsert-XrmForm -Id $formId -EntityLogicalName "account" -Name "Custom Main Form" -FormXml $xml -FormType 2 -SolutionUniqueName "MySolution";
#>
function Upsert-XrmForm {
    [CmdletBinding(DefaultParameterSetName = "ByName")]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $Id,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $true, ParameterSetName = "ByName")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = "ByLabels")]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Labels,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $FormXml,

        [Parameter(Mandatory = $true)]
        [int]
        $FormType,

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
        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            $Name = Get-XrmLabelText -Labels $Labels -LanguageCode $LanguageCode;
        }

        $attributes = @{
            "name"    = $Name;
            "formxml" = $FormXml;
            "type"    = (New-XrmOptionSetValue -Value $FormType);
        };
        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $attributes["objecttypecode"] = $EntityLogicalName;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $attributes["description"] = $Description;
        }

        $record = New-XrmEntity -LogicalName "systemform" -Id $Id -Attributes $attributes;

        $XrmClient | Upsert-XrmRecord -Record $record | Out-Null;
        $formReference = New-XrmEntityReference -LogicalName "systemform" -Id $Id;

        # Persist the multilingual name as real translations (SetLocLabels) so each language sees its own label.
        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            Set-XrmLocalizedLabel -XrmClient $XrmClient -EntityMoniker $formReference -AttributeName "name" -Labels $Labels | Out-Null;
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $Id -ComponentType 60 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        $formReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmForm -Alias *;

Register-ArgumentCompleter -CommandName Upsert-XrmForm -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
