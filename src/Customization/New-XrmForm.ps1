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

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created systemform record.

    .EXAMPLE
    $ref = New-XrmForm -EntityLogicalName "account" -Name "Custom Main Form" -FormXml $xml -FormType 2;
    $ref = New-XrmForm -Name "Sales Dashboard" -FormXml $xml -FormType 0;
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
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $attributes = @{
            "name"    = $Name;
            "formxml" = $FormXml;
            "type"    = $FormType;
        };

        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $attributes["objecttypecode"] = $EntityLogicalName;
        }

        $record = New-XrmEntity -LogicalName "systemform" -Attributes $attributes;

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
