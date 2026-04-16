<#
    .SYNOPSIS
    Remove a PCF custom control from a form field.

    .DESCRIPTION
    Remove a Power Apps Component Framework (PCF) custom control binding from a field in a model-driven app form
    by modifying the FormXML of the systemform record.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER FormReference
    EntityReference of the systemform record to modify.

    .PARAMETER FieldName
    Logical name of the field to remove the control from.

    .PARAMETER ControlName
    Full unique name of the PCF control to remove. Optional. If not specified, removes all custom controls from the field.

    .PARAMETER Publish
    Publish customizations after update. Default: true.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $formRef = New-XrmEntityReference -LogicalName "systemform" -Id $formId;
    Remove-XrmFormControl -FormReference $formRef -FieldName "revenue" -ControlName "MscrmControls.FieldControls.LinearSliderControl";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/component-framework/add-custom-controls-to-a-field-or-entity
#>
function Remove-XrmFormControl {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $FormReference,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $FieldName,

        [Parameter(Mandatory = $false)]
        [string]
        $ControlName,

        [Parameter(Mandatory = $false)]
        [bool]
        $Publish = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $form = $XrmClient | Get-XrmRecord -LogicalName "systemform" -Id $FormReference.Id -Columns "formxml";
        $formXmlString = $form["formxml"];

        [xml]$formXml = $formXmlString;

        $controlNode = $formXml.SelectSingleNode("//control[@datafieldname='$FieldName']");
        if (-not $controlNode) {
            throw "Field '$FieldName' not found in the form XML.";
        }

        $controlId = $controlNode.GetAttribute("id");
        $removed = $false;

        # Find controlDescription entries for this control
        $descriptions = $formXml.SelectNodes("//controlDescription[@forControl='$controlId']");
        foreach ($desc in $descriptions) {
            if ($PSBoundParameters.ContainsKey('ControlName')) {
                $customCtrl = $desc.SelectSingleNode("customControl[@name='$ControlName']");
                if ($customCtrl) {
                    $desc.ParentNode.RemoveChild($desc) | Out-Null;
                    $removed = $true;
                }
            }
            else {
                $desc.ParentNode.RemoveChild($desc) | Out-Null;
                $removed = $true;
            }
        }

        if (-not $removed) {
            Write-Warning "No custom control found for field '$FieldName'.";
            return;
        }

        $updatedFormXml = $formXml.OuterXml;
        $updateRecord = New-XrmEntity -LogicalName "systemform";
        $updateRecord.Id = $FormReference.Id;
        $updateRecord["formxml"] = $updatedFormXml;

        $XrmClient | Update-XrmRecord -Record $updateRecord;

        if ($Publish) {
            Publish-XrmCustomizations;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmFormControl -Alias *;
