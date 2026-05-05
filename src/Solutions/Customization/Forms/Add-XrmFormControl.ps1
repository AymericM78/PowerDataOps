<#
    .SYNOPSIS
    Add a PCF custom control to a form field.

    .DESCRIPTION
    Add a Power Apps Component Framework (PCF) custom control binding onto a field in a model-driven app form
    by modifying the FormXML of the systemform record.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER FormReference
    EntityReference of the systemform record to modify.

    .PARAMETER FieldName
    Logical name of the field on the form to bind the control to.

    .PARAMETER ControlName
    Full unique name of the PCF control (e.g. "MscrmControls.FieldControls.LinearSliderControl").

    .PARAMETER Parameters
    Hashtable of control parameters with their static values. Optional.
    Example: @{ "min" = "0"; "max" = "1000"; "step" = "1" }

    .PARAMETER Publish
    Publish customizations after update. Default: true.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $formRef = New-XrmEntityReference -LogicalName "systemform" -Id $formId;
    Add-XrmFormControl -FormReference $formRef -FieldName "revenue" -ControlName "MscrmControls.FieldControls.LinearSliderControl" -Parameters @{ "min" = "0"; "max" = "1000000"; "step" = "100" };

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/component-framework/add-custom-controls-to-a-field-or-entity
#>
function Add-XrmFormControl {
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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ControlName,

        [Parameter(Mandatory = $false)]
        [Hashtable]
        $Parameters,

        [Parameter(Mandatory = $false)]
        [bool]
        $Publish = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        # Retrieve current form
        $form = $XrmClient | Get-XrmRecord -LogicalName "systemform" -Id $FormReference.Id -Columns "formxml";
        $formXmlString = $form["formxml"];

        [xml]$formXml = $formXmlString;

        # Find the control node for the field
        $controlNode = $formXml.SelectSingleNode("//control[@datafieldname='$FieldName']");
        if (-not $controlNode) {
            throw "Field '$FieldName' not found in the form XML.";
        }

        $controlId = $controlNode.GetAttribute("id");

        # Build customControl element
        $customControlNode = $formXml.CreateElement("customControl");
        $customControlNode.SetAttribute("name", $ControlName);
        $customControlNode.SetAttribute("formFactor", "0");

        # Add parameters
        if ($Parameters) {
            $parametersNode = $formXml.CreateElement("parameters");
            foreach ($key in $Parameters.Keys) {
                $paramNode = $formXml.CreateElement($key);
                $paramNode.SetAttribute("type", "Whole.None");
                $paramNode.InnerText = "val";

                $staticNode = $formXml.CreateElement("bind");
                $staticNode.SetAttribute("static", "true");
                $staticNode.SetAttribute("value", $Parameters[$key]);

                $paramNode = $formXml.CreateElement($key);
                $paramNode.InnerText = $Parameters[$key];
                $parametersNode.AppendChild($paramNode) | Out-Null;
            }
            $customControlNode.AppendChild($parametersNode) | Out-Null;
        }

        # Find or create controlDescriptions node
        $controlDescriptions = $controlNode.SelectSingleNode("controlDescriptions");
        if (-not $controlDescriptions) {
            $controlDescriptions = $formXml.CreateElement("controlDescriptions");
            $controlNode.AppendChild($controlDescriptions) | Out-Null;
        }

        # Add controlDescription entry
        $controlDescription = $formXml.CreateElement("controlDescription");
        $controlDescription.SetAttribute("forControl", $controlId);
        $controlDescription.AppendChild($customControlNode) | Out-Null;
        $controlDescriptions.AppendChild($controlDescription) | Out-Null;

        # Update form
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

Export-ModuleMember -Function Add-XrmFormControl -Alias *;
