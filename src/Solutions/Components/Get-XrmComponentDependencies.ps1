<#
    .SYNOPSIS
    Retrieve the dependencies of a solution component.

    .DESCRIPTION
    Ask the platform which components depend on a component, or which components it requires:
    - ForDelete (RetrieveDependenciesForDelete): the components that prevent deleting it;
    - Dependent (RetrieveDependentComponents): every component that depends on it;
    - Required (RetrieveRequiredComponents): the components it requires.
    Each row carries dependentcomponentobjectid, dependentcomponenttype, requiredcomponentobjectid, requiredcomponenttype, dependencytype, plus DependentComponentTypeName and RequiredComponentTypeName (see Get-XrmSolutionComponentName).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ComponentId
    Component unique identifier (objectid: the MetadataId for tables and columns, the row id for the other components).

    .PARAMETER ComponentType
    Solution component type code (see Get-XrmSolutionComponentType).

    .PARAMETER Kind
    ForDelete, Dependent or Required. (Default: ForDelete)

    .OUTPUTS
    PSCustomObject[]. Dependency rows (XrmObject).

    .EXAMPLE
    $table = Get-XrmEntityMetadata -XrmClient $xrmClient -LogicalName "new_project" -Filter Entity;
    $blocking = Get-XrmComponentDependencies -XrmClient $xrmClient -ComponentId $table.MetadataId -ComponentType 1 -Kind ForDelete;
    $blocking | Select-Object DependentComponentTypeName, dependentcomponentobjectid;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmComponentDependencies.md
#>
function Get-XrmComponentDependencies {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
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
        [int]
        $ComponentType,

        [Parameter(Mandatory = $false)]
        [ValidateSet("ForDelete", "Dependent", "Required")]
        [String]
        $Kind = "ForDelete"
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $messageNames = @{ ForDelete = "RetrieveDependenciesForDelete"; Dependent = "RetrieveDependentComponents"; Required = "RetrieveRequiredComponents" };
        $request = New-XrmRequest -Name $messageNames[$Kind];
        $request = $request | Add-XrmRequestParameter -Name "ObjectId" -Value $ComponentId;
        $request = $request | Add-XrmRequestParameter -Name "ComponentType" -Value $ComponentType;
        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        if ($null -eq $response) {
            return;
        }

        $typeNames = @{};
        foreach ($dependency in $response.Results["EntityCollection"].Entities) {
            $row = $dependency | ConvertTo-XrmObject;
            foreach ($side in "dependent", "required") {
                $typeCode = $dependency["$($side)componenttype"];
                $typeName = $null;
                if ($typeCode) {
                    try {
                        $typeName = Get-XrmSolutionComponentName -XrmClient $XrmClient -SolutionComponentType $typeCode.Value -Cache $typeNames;
                    }
                    catch {
                        $typeName = $null;
                    }
                }
                $propertyName = $(if ($side -eq "dependent") { "DependentComponentTypeName" } else { "RequiredComponentTypeName" });
                $row | Add-Member -MemberType NoteProperty -Name $propertyName -Value $typeName;
            }
            $row;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmComponentDependencies -Alias *;
