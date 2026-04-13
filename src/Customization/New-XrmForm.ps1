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

    .PARAMETER FormXml
    Form XML definition.

    .PARAMETER FormType
    Form type (2=Main, 5=Mobile, 6=QuickCreate, 7=QuickView).

    .PARAMETER Description
    Form description.

    .PARAMETER SourceReference
    EntityReference of an existing systemform to initialize from using the InitializeFrom SDK message.
    When provided, the new form is pre-populated with values from the source form, then overridden by provided parameters.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created systemform record.

    .EXAMPLE
    $ref = New-XrmForm -EntityLogicalName "account" -Name "Custom Main Form" -FormXml $xml -FormType 2;
    $ref = New-XrmForm -Name "Sales Dashboard" -FormXml $xml -FormType 0;

    .EXAMPLE
    $sourceRef = New-XrmEntityReference -LogicalName "systemform" -Id $existingFormId;
    $ref = New-XrmForm -SourceReference $sourceRef -Name "Copied Form" -FormXml $xml -FormType 2;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/initializefrom
#>
function New-XrmForm {
    [CmdletBinding()]
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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

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
        $SourceReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSBoundParameters.ContainsKey('SourceReference')) {
            $initRequest = New-XrmRequest -Name "InitializeFrom";
            $initRequest = $initRequest | Add-XrmRequestParameter -Name "EntityMoniker" -Value $SourceReference;
            $initRequest = $initRequest | Add-XrmRequestParameter -Name "TargetEntityName" -Value "systemform";
            $initRequest = $initRequest | Add-XrmRequestParameter -Name "TargetFieldType" -Value ([Microsoft.Crm.Sdk.Messages.TargetFieldType]::All);
            $initResponse = $XrmClient | Invoke-XrmRequest -Request $initRequest;
            $record = $initResponse.Results["Entity"];
            $record.Attributes["name"] = $Name;
            $record.Attributes["formxml"] = $FormXml;
            $record.Attributes["type"] = $FormType;
        }
        else {
            $attributes = @{
                "name"    = $Name;
                "formxml" = $FormXml;
                "type"    = $FormType;
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
        New-XrmEntityReference -LogicalName "systemform" -Id $id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmForm -Alias *;

Register-ArgumentCompleter -CommandName New-XrmForm -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
