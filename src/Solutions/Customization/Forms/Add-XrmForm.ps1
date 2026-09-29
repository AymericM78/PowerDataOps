<#
    .SYNOPSIS
    Create a new form in Microsoft Dataverse.

    .DESCRIPTION
    Create a new systemform record.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name the form belongs to. Optional for dashboards.

    .PARAMETER Name
    Form display name.

    .PARAMETER Labels
    Hashtable of language code to display name. Alternative to -Name. The stored 'name' attribute is resolved from -LanguageCode (fallback: lowest language code), and every provided language is persisted as a real translation via SetLocLabels so each user sees the label in their own language. Example: @{ 1033 = "Main Form"; 1036 = "Formulaire principal" }

    .PARAMETER LanguageCode
    Language code used to pick the stored 'name' from -Labels. Default: 1033.

    .PARAMETER FormXml
    Form XML definition.

    .PARAMETER FormType
    Form type (2=Main, 5=Mobile, 6=QuickCreate, 7=QuickView).

    .PARAMETER Description
    Form description.

    .PARAMETER SourceReference
    EntityReference of an existing systemform to initialize from using the InitializeFrom SDK message.
    When provided, the new form is pre-populated with values from the source form, then overridden by provided parameters.

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the created form is automatically added to this solution.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created systemform record.

    .EXAMPLE
    $ref = Add-XrmForm -EntityLogicalName "account" -Name "Custom Main Form" -FormXml $xml -FormType 2;
    $ref = Add-XrmForm -Name "Sales Dashboard" -FormXml $xml -FormType 0;

    .EXAMPLE
    $sourceRef = New-XrmEntityReference -LogicalName "systemform" -Id $existingFormId;
    $ref = Add-XrmForm -SourceReference $sourceRef -Name "Copied Form" -FormXml $xml -FormType 2 -SolutionUniqueName "MySolution";

    .EXAMPLE
    $ref = Add-XrmForm -EntityLogicalName "account" -Labels @{ 1033 = "Main Form"; 1036 = "Formulaire principal" } -LanguageCode 1036 -FormXml $xml -FormType 2;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/initializefrom
#>
function Add-XrmForm {
    [CmdletBinding(DefaultParameterSetName = "ByName", SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

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
        [Microsoft.Xrm.Sdk.EntityReference]
        $SourceReference,

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

        $formTypeCode = (New-XrmOptionSetValue -Value $FormType);
        if ($PSBoundParameters.ContainsKey('SourceReference')) {
            $initRequest = New-XrmRequest -Name "InitializeFrom";
            $initRequest = $initRequest | Add-XrmRequestParameter -Name "EntityMoniker" -Value $SourceReference;
            $initRequest = $initRequest | Add-XrmRequestParameter -Name "TargetEntityName" -Value "systemform";
            $initRequest = $initRequest | Add-XrmRequestParameter -Name "TargetFieldType" -Value ([Microsoft.Crm.Sdk.Messages.TargetFieldType]::All);
            $initResponse = $XrmClient | Invoke-XrmRequest -Request $initRequest;
            $record = $initResponse.Results["Entity"];
            $record.Attributes["name"] = $Name;
            $record.Attributes["formxml"] = $FormXml;
            $record.Attributes["type"] = $formTypeCode;
        }
        else {
            $attributes = @{
                "name"    = $Name;
                "formxml" = $FormXml;
                "type"    = $formTypeCode;
            };

            if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
                $attributes["objecttypecode"] = $EntityLogicalName;
            }

            $record = New-XrmEntity -LogicalName "systemform" -Attributes $attributes;
        }

        if ($PSBoundParameters.ContainsKey('Description')) {
            $record.Attributes["description"] = $Description;
        }

        $id = Add-XrmRecord -XrmClient $XrmClient -Record $record;
        $formReference = New-XrmEntityReference -LogicalName "systemform" -Id $id;

        # Persist the multilingual name as real translations (SetLocLabels) so each language sees its own label.
        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            Set-XrmLocalizedLabel -XrmClient $XrmClient -EntityMoniker $formReference -AttributeName "name" -Labels $Labels | Out-Null;
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $id -ComponentType 60 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        $formReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmForm -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmForm -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
