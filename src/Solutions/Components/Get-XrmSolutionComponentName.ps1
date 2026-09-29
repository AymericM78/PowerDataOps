<#
    .SYNOPSIS
    Get Solution Component name from Id.

    .DESCRIPTION
    Retrieve component name from its number.
    Classic component types come from a fixed table. The types added by solution-aware tables (connection references, custom APIs, environment variables...) depend on the organization: when XrmClient is available they are read from solutioncomponentdefinition.

    .PARAMETER SolutionComponentType
    Solution component type number.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance, used for the types that are not in the fixed table. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Cache
    Hashtable owned by the caller, used to store and reuse the names read from the organization. (Default: no cache)

    .OUTPUTS
    System.String. Component type name.

    .EXAMPLE
    $name = Get-XrmSolutionComponentName -SolutionComponentType 26;   # SavedQuery

    .EXAMPLE
    $name = Get-XrmSolutionComponentName -SolutionComponentType $component.componenttype_Value.Value -XrmClient $xrmClient;

    .LINK
    https://docs.microsoft.com/en-us/dynamics365/customer-engagement/web-api/solutioncomponent?view=dynamics-ce-odata-9
#>
function Get-XrmSolutionComponentName {
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]
        $SolutionComponentType,

        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Hashtable]
        $Cache
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $componentTypeDefinitions = Get-XrmSolutionComponentTypeTableInternal;
        if ($componentTypeDefinitions.Contains($SolutionComponentType)) {
            return $componentTypeDefinitions[$SolutionComponentType];
        }

        $cacheKey = "type|$SolutionComponentType";
        if ($PSBoundParameters.ContainsKey('Cache') -and $Cache.ContainsKey($cacheKey)) {
            return $Cache[$cacheKey];
        }

        $name = $null;
        if ($XrmClient) {
            $query = New-XrmQueryExpression -LogicalName "solutioncomponentdefinition" -Columns "name" -TopCount 1;
            $query = $query | Add-XrmQueryCondition -Field "solutioncomponenttype" -Condition Equal -Values $SolutionComponentType;
            $definition = $XrmClient | Get-XrmMultipleRecords -Query $query -AsEntity | Select-Object -First 1;
            if ($definition) {
                $name = $definition["name"];
            }
        }
        if (-not $name) {
            throw "Unknown solution component type '$SolutionComponentType'!";
        }
        if ($PSBoundParameters.ContainsKey('Cache')) {
            $Cache[$cacheKey] = $name;
        }
        $name;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmSolutionComponentName -Alias *;
