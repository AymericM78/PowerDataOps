<#
    .SYNOPSIS
    List PCF custom controls configured on a form.

    .DESCRIPTION
    Parse the FormXML of a systemform record and return all custom control bindings (PCF controls).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER FormReference
    EntityReference of the systemform record to inspect.

    .OUTPUTS
    PSCustomObject[]. Array of objects with FieldName, ControlId, ControlName, and FormFactor properties.

    .EXAMPLE
    $formRef = New-XrmEntityReference -LogicalName "systemform" -Id $formId;
    $controls = Get-XrmFormControls -FormReference $formRef;
    $controls | Format-Table;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/component-framework/add-custom-controls-to-a-field-or-entity
#>
function Get-XrmFormControls {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $FormReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $form = $XrmClient | Get-XrmRecord -LogicalName "systemform" -Id $FormReference.Id -Columns "formxml";
        $formXmlString = $form["formxml"];

        [xml]$formXml = $formXmlString;

        $results = @();

        # Find all controlDescription elements
        $descriptions = $formXml.SelectNodes("//controlDescription");
        foreach ($desc in $descriptions) {
            $forControlId = $desc.GetAttribute("forControl");

            # Find the control node by id to get the field name
            $controlNode = $formXml.SelectSingleNode("//control[@id='$forControlId']");
            $fieldName = if ($controlNode) { $controlNode.GetAttribute("datafieldname") } else { "" };

            $customControls = $desc.SelectNodes("customControl");
            foreach ($cc in $customControls) {
                $results += [PSCustomObject]@{
                    FieldName   = $fieldName;
                    ControlId   = $forControlId;
                    ControlName = $cc.GetAttribute("name");
                    FormFactor  = $cc.GetAttribute("formFactor");
                };
            }
        }

        $results;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmFormControls -Alias *;
