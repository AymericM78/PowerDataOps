<#
    .SYNOPSIS
    Add multiple components to a solution.

    .DESCRIPTION
    Adds a batch of components to the specified unmanaged solution and returns
    one result object per component.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name where components are added.

    .PARAMETER Components
    Collection of component descriptors. Supported input shapes:
    - @{ ComponentId = <Guid>; ComponentType = <int> }
    - solutioncomponent rows with objectid and componenttype/componenttype_Value

    .PARAMETER DoNotIncludeSubcomponents
    Indicates whether subcomponents should be included. Default: true.

    .PARAMETER AddRequiredComponents
    Indicates whether required components should be included. Default: false.

    .PARAMETER ContinueOnError
    Continue processing remaining components when one component fails. Default: true.

    .OUTPUTS
    PSCustomObject array.

    .EXAMPLE
    $components = @(
        [pscustomobject]@{ ComponentId = $entityId; ComponentType = 1 },
        [pscustomobject]@{ ComponentId = $viewId; ComponentType = 26 }
    );
    Add-XrmSolutionComponents -SolutionUniqueName "MySolution" -Components $components;
#>
function Add-XrmSolutionComponents {
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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Object[]]
        $Components,

        [Parameter(Mandatory = $false)]
        [bool]
        $DoNotIncludeSubcomponents = $true,

        [Parameter(Mandatory = $false)]
        [bool]
        $AddRequiredComponents = $false,

        [Parameter(Mandatory = $false)]
        [bool]
        $ContinueOnError = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        [System.Collections.ArrayList]$results = @();
        if (-not $Components -or $Components.Count -eq 0) {
            return $results;
        }

        ForEach-ObjectWithProgress -Collection $Components -OperationName "Adding components to $SolutionUniqueName" -ScriptBlock {
            param($component)

            $componentId = [Guid]::Empty;
            $componentType = $null;
            $response = $null;

            $componentIdRaw = $null;
            if ($component.PSObject.Properties.Match("ComponentId").Count -gt 0) {
                $componentIdRaw = $component.ComponentId;
            }
            elseif ($component.PSObject.Properties.Match("objectid").Count -gt 0) {
                $componentIdRaw = $component.objectid;
            }
            elseif ($component.PSObject.Properties.Match("Id").Count -gt 0) {
                $componentIdRaw = $component.Id;
            }

            $componentTypeRaw = $null;
            if ($component.PSObject.Properties.Match("ComponentType").Count -gt 0) {
                $componentTypeRaw = $component.ComponentType;
            }
            elseif ($component.PSObject.Properties.Match("componenttype_Value").Count -gt 0) {
                $componentTypeRaw = $component.componenttype_Value;
            }
            elseif ($component.PSObject.Properties.Match("componenttype").Count -gt 0) {
                $componentTypeRaw = $component.componenttype;
            }

            if ($componentTypeRaw -and $componentTypeRaw.PSObject.Properties.Match("Value").Count -gt 0) {
                $componentTypeRaw = $componentTypeRaw.Value;
            }

            $parseError = $null;
            try {
                $componentId = [Guid]::Parse($componentIdRaw.ToString());
                $componentType = [int]::Parse($componentTypeRaw.ToString());
            }
            catch {
                $parseError = $_.Exception.Message;
            }

            if ($parseError) {
                $result = [pscustomobject]@{
                    "ComponentId"   = $componentIdRaw;
                    "ComponentType" = $componentTypeRaw;
                    "Success"       = $false;
                    "ErrorMessage"  = "Invalid component descriptor: $parseError";
                    "Response"      = $null;
                };
                $results.Add($result) | Out-Null;

                if (-not $ContinueOnError) {
                    throw $result.ErrorMessage;
                }
                return;
            }

            try {
                $response = $XrmClient | Add-XrmSolutionComponent `
                    -SolutionUniqueName $SolutionUniqueName `
                    -ComponentId $componentId `
                    -ComponentType $componentType `
                    -DoNotIncludeSubcomponents $DoNotIncludeSubcomponents `
                    -AddRequiredComponents $AddRequiredComponents;

                $result = [pscustomobject]@{
                    "ComponentId"   = $componentId;
                    "ComponentType" = $componentType;
                    "Success"       = $true;
                    "ErrorMessage"  = $null;
                    "Response"      = $response;
                };
                $results.Add($result) | Out-Null;
            }
            catch {
                $result = [pscustomobject]@{
                    "ComponentId"   = $componentId;
                    "ComponentType" = $componentType;
                    "Success"       = $false;
                    "ErrorMessage"  = $_.Exception.Message;
                    "Response"      = $null;
                };
                $results.Add($result) | Out-Null;

                if (-not $ContinueOnError) {
                    throw $_.Exception;
                }
            }
        };

        $results;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmSolutionComponents -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmSolutionComponents -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename; };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}
