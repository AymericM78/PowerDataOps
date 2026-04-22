<#
    .SYNOPSIS
    Test active-layer customization for a solution component.

    .DESCRIPTION
    Checks whether a component has meaningful customizations in the Active layer
    by querying msdyn_componentlayer and parsing msdyn_changes.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ComponentId
    Solution component unique identifier.

    .PARAMETER SolutionComponentName
    Solution component name (for example: Entity, Attribute, SavedQuery, SystemForm).

    .PARAMETER ExcludedProperties
    Changed properties to ignore when evaluating meaningful customizations.

    .PARAMETER IncludedProperties
    If provided, only these changed properties are evaluated.

    .PARAMETER ReturnDetails
    Return a detailed object instead of a boolean.

    .OUTPUTS
    System.Boolean or PSCustomObject.

    .EXAMPLE
    $isCustomized = Test-XrmComponentCustomization -ComponentId $componentId -SolutionComponentName "Attribute";

    .EXAMPLE
    $details = Test-XrmComponentCustomization -ComponentId $componentId -SolutionComponentName "SystemForm" -ReturnDetails;
#>
function Test-XrmComponentCustomization {
    [CmdletBinding()]
    [OutputType([System.Boolean], [PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $ComponentId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionComponentName,

        [Parameter(Mandatory = $false)]
        [String[]]
        $ExcludedProperties = @("displaymask", "createdon", "modifiedon", "attributetypeid", "attributelogicaltypeid"),

        [Parameter(Mandatory = $false)]
        [String[]]
        $IncludedProperties = @(),

        [Parameter(Mandatory = $false)]
        [switch]
        $ReturnDetails
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        $queryUnmanagedComponent = New-XrmQueryExpression -LogicalName "msdyn_componentlayer" -Columns "msdyn_changes", "msdyn_componentid", "msdyn_solutioncomponentname" -TopCount 1;
        $queryUnmanagedComponent = $queryUnmanagedComponent | Add-XrmQueryCondition -Field "msdyn_solutionname" -Condition Equal -Values "Active";
        $queryUnmanagedComponent = $queryUnmanagedComponent | Add-XrmQueryCondition -Field "msdyn_solutioncomponentname" -Condition Equal -Values $SolutionComponentName;
        $queryUnmanagedComponent = $queryUnmanagedComponent | Add-XrmQueryCondition -Field "msdyn_componentid" -Condition Equal -Values $ComponentId.ToString();

        $unmanagedComponents = @($XrmClient | Get-XrmMultipleRecords -Query $queryUnmanagedComponent);
        if ($unmanagedComponents.Count -eq 0) {
            if ($ReturnDetails) {
                return [pscustomobject]@{
                    "ComponentId"           = $ComponentId;
                    "SolutionComponentName" = $SolutionComponentName;
                    "HasCustomization"      = $false;
                    "ChangedProperties"     = @();
                    "LayerId"               = [Guid]::Empty;
                    "RawChanges"            = $null;
                    "Layer"                 = $null;
                };
            }
            return $false;
        }

        $layer = $unmanagedComponents | Select-Object -First 1;
        $rawChanges = $layer.msdyn_changes;
        if ([string]::IsNullOrWhiteSpace([string]$rawChanges)) {
            if ($ReturnDetails) {
                return [pscustomobject]@{
                    "ComponentId"           = $ComponentId;
                    "SolutionComponentName" = $SolutionComponentName;
                    "HasCustomization"      = $false;
                    "ChangedProperties"     = @();
                    "LayerId"               = $layer.Id;
                    "RawChanges"            = $rawChanges;
                    "Layer"                 = $layer;
                };
            }
            return $false;
        }

        try {
            $changes = $rawChanges | ConvertFrom-Json;
        }
        catch {
            if ($ReturnDetails) {
                return [pscustomobject]@{
                    "ComponentId"           = $ComponentId;
                    "SolutionComponentName" = $SolutionComponentName;
                    "HasCustomization"      = $false;
                    "ChangedProperties"     = @();
                    "LayerId"               = $layer.Id;
                    "RawChanges"            = $rawChanges;
                    "Layer"                 = $layer;
                    "Error"                 = $_.Exception.Message;
                };
            }
            return $false;
        }

        $changedPropertiesSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase);
        $changeAttributes = @();

        if ($changes -and $changes.PSObject.Properties.Match("Attributes").Count -gt 0) {
            $changeAttributes = @($changes.Attributes);
        }
        elseif ($changes -is [System.Collections.IDictionary]) {
            $changeAttributes = @($changes.GetEnumerator());
        }

        foreach ($change in $changeAttributes) {
            $changePropertyName = $null;

            if ($null -eq $change) {
                continue;
            }
            elseif ($change -is [string]) {
                $changePropertyName = $change;
            }
            elseif ($change -is [System.Collections.DictionaryEntry]) {
                $changePropertyName = [string]$change.Key;
            }
            elseif ($change.PSObject.Properties.Match("Key").Count -gt 0) {
                $changePropertyName = [string]$change.Key;
            }
            elseif ($change.PSObject.Properties.Match("key").Count -gt 0) {
                $changePropertyName = [string]$change.key;
            }

            if ([string]::IsNullOrWhiteSpace($changePropertyName)) {
                continue;
            }

            if ($IncludedProperties.Count -gt 0 -and -not ($IncludedProperties -contains $changePropertyName)) {
                continue;
            }

            if ($ExcludedProperties -contains $changePropertyName) {
                continue;
            }

            [void]$changedPropertiesSet.Add($changePropertyName);
        }

        $changedProperties = @($changedPropertiesSet | Sort-Object);
        $hasCustomization = ($changedProperties.Count -gt 0);

        if ($ReturnDetails) {
            return [pscustomobject]@{
                "ComponentId"           = $ComponentId;
                "SolutionComponentName" = $SolutionComponentName;
                "HasCustomization"      = $hasCustomization;
                "ChangedProperties"     = $changedProperties;
                "LayerId"               = $layer.Id;
                "RawChanges"            = $rawChanges;
                "Layer"                 = $layer;
            };
        }

        $hasCustomization;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmComponentCustomization -Alias *;
