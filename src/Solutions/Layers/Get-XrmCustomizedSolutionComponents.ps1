<#
    .SYNOPSIS
    Get customized solution components from Active layer.

    .DESCRIPTION
    Retrieves solution components from a solution, then keeps only components
    with meaningful Active-layer customizations.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name where to inspect components.

    .PARAMETER ComponentTypes
    Solution component types to inspect. Default: inspect all component types in solution.

    .PARAMETER ExcludedProperties
    Changed properties to ignore when evaluating meaningful customizations.

    .PARAMETER IncludedProperties
    If provided, only these changed properties are evaluated.

    .PARAMETER IncludeDetails
    Include changed properties and layer metadata in output.

    .OUTPUTS
    PSCustomObject array.

    .EXAMPLE
    $components = Get-XrmCustomizedSolutionComponents -SolutionUniqueName "MySolution";

    .EXAMPLE
    $components = Get-XrmCustomizedSolutionComponents -SolutionUniqueName "MySolution" -ComponentTypes @(60, 26) -IncludeDetails;
#>
function Get-XrmCustomizedSolutionComponents {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [int[]]
        $ComponentTypes = @(),

        [Parameter(Mandatory = $false)]
        [String[]]
        $ExcludedProperties = @("displaymask", "createdon", "modifiedon", "attributetypeid", "attributelogicaltypeid"),

        [Parameter(Mandatory = $false)]
        [String[]]
        $IncludedProperties = @(),

        [Parameter(Mandatory = $false)]
        [switch]
        $IncludeDetails
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        $components = @($XrmClient | Get-XrmSolutionComponents -SolutionUniqueName $SolutionUniqueName -ComponentTypes $ComponentTypes);
        if ($components.Count -eq 0) {
            return @();
        }

        [System.Collections.ArrayList]$customizedComponents = @();

        ForEach-ObjectWithProgress -Collection $components -OperationName "Inspecting active-layer customizations for $SolutionUniqueName" -ScriptBlock {
            param($component)

            $componentId = [Guid]::Empty;
            $componentType = $null;

            try {
                if ($component.PSObject.Properties.Match("objectid").Count -gt 0 -and $component.objectid) {
                    $componentId = [Guid]::Parse($component.objectid.ToString());
                }
                else {
                    return;
                }
            }
            catch {
                return;
            }

            if ($component.PSObject.Properties.Match("componenttype_Value").Count -gt 0 -and $component.componenttype_Value) {
                if ($component.componenttype_Value.PSObject.Properties.Match("Value").Count -gt 0) {
                    $componentType = [int]$component.componenttype_Value.Value;
                }
                else {
                    $componentType = [int]$component.componenttype_Value;
                }
            }
            elseif ($component.PSObject.Properties.Match("componenttype").Count -gt 0 -and $component.componenttype) {
                if ($component.componenttype -is [int]) {
                    $componentType = [int]$component.componenttype;
                }
                elseif ($component.componenttype.PSObject.Properties.Match("Value").Count -gt 0) {
                    $componentType = [int]$component.componenttype.Value;
                }
            }

            if ($null -eq $componentType) {
                return;
            }

            try {
                $componentTypeName = Get-XrmSolutionComponentName -SolutionComponentType $componentType;
            }
            catch {
                return;
            }

            $customizationCheck = $XrmClient | Test-XrmComponentCustomization `
                -ComponentId $componentId `
                -SolutionComponentName $componentTypeName `
                -ExcludedProperties $ExcludedProperties `
                -IncludedProperties $IncludedProperties `
                -ReturnDetails:$IncludeDetails;

            $isCustomized = $false;
            if ($IncludeDetails) {
                $isCustomized = [bool]$customizationCheck.HasCustomization;
            }
            else {
                $isCustomized = [bool]$customizationCheck;
            }

            if (-not $isCustomized) {
                return;
            }

            if ($IncludeDetails) {
                $customizedComponent = [pscustomobject]@{
                    "ComponentId"       = $componentId;
                    "ComponentType"     = $componentType;
                    "ComponentTypeName" = $componentTypeName;
                    "IsCustomized"      = $true;
                    "ChangedProperties" = $customizationCheck.ChangedProperties;
                    "LayerId"           = $customizationCheck.LayerId;
                };
                $customizedComponents.Add($customizedComponent) | Out-Null;
            }
            else {
                $customizedComponent = [pscustomobject]@{
                    "ComponentId"       = $componentId;
                    "ComponentType"     = $componentType;
                    "ComponentTypeName" = $componentTypeName;
                    "IsCustomized"      = $true;
                };
                $customizedComponents.Add($customizedComponent) | Out-Null;
            }
        };

        $customizedComponents;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmCustomizedSolutionComponents -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmCustomizedSolutionComponents -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename; };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}
