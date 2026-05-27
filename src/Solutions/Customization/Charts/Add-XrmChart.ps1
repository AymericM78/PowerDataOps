<#
    .SYNOPSIS
    Create a new chart in Microsoft Dataverse.

    .DESCRIPTION
    Create a new savedqueryvisualization record (system chart).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name the chart belongs to.

    .PARAMETER Name
    Chart display name.

    .PARAMETER Labels
    Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code), and every provided language is persisted as a real translation via SetLocLabels so each user sees the label in their own language. Example: @{ 1033 = "Revenue"; 1036 = "Chiffre d'affaires" }

    .PARAMETER LanguageCode
    Language code used to pick the stored 'name' from -Labels. Default: 1033.

    .PARAMETER DataDescription
    Data description XML defining the chart data source.

    .PARAMETER PresentationDescription
    Presentation description XML defining the chart visual.

    .PARAMETER Description
    Chart description.

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the created chart is automatically added to this solution.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created savedqueryvisualization record.

    .EXAMPLE
    $ref = Add-XrmChart -EntityLogicalName "account" -Name "Revenue Chart" -DataDescription $dataXml -PresentationDescription $presXml;
    $ref = Add-XrmChart -EntityLogicalName "account" -Name "Revenue Chart" -DataDescription $dataXml -PresentationDescription $presXml -SolutionUniqueName "MySolution";

    .EXAMPLE
    $ref = Add-XrmChart -EntityLogicalName "account" -Labels @{ 1033 = "Revenue"; 1036 = "Chiffre d'affaires" } -LanguageCode 1036 -DataDescription $dataXml -PresentationDescription $presXml;
#>
function Add-XrmChart {
    [CmdletBinding(DefaultParameterSetName = "ByName")]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
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
        $DataDescription,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PresentationDescription,

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

        $record = New-XrmEntity -LogicalName "savedqueryvisualization" -Attributes @{
            "primaryentitytypecode"  = $EntityLogicalName;
            "name"                   = $Name;
            "datadescription"        = $DataDescription;
            "presentationdescription" = $PresentationDescription;
        };

        if ($PSBoundParameters.ContainsKey('Description')) {
            $record.Attributes["description"] = $Description;
        }

        $id = Add-XrmRecord -XrmClient $XrmClient -Record $record;
        $chartReference = New-XrmEntityReference -LogicalName "savedqueryvisualization" -Id $id;

        # Persist the multilingual name as real translations (SetLocLabels) so each language sees its own label.
        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            Set-XrmLocalizedLabel -XrmClient $XrmClient -EntityMoniker $chartReference -AttributeName "name" -Labels $Labels | Out-Null;
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $id -ComponentType 59 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        $chartReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmChart -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmChart -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
