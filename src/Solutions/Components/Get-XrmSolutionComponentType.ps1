<#
    .SYNOPSIS
    Get the solution component type code of a table or a component name.

    .DESCRIPTION
    Return the solution component type code to use with Add-XrmSolutionComponent and friends.
    The organization is asked first (solutioncomponentdefinition): the code of the components brought by solution-aware tables (connection references, custom APIs...) depends on the organization.
    For the classic components, which solutioncomponentdefinition does not list (views, forms, web resources, app modules...), a fixed table is used.
    Raises an error when the type is unknown.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalName
    Logical name of the table holding the component (e.g. "connectionreference", "savedquery", "webresource").

    .PARAMETER Name
    Component type name (e.g. "SavedQuery", "connectionreference"), as returned by Get-XrmSolutionComponentName.

    .PARAMETER Cache
    Hashtable owned by the caller, used to store and reuse the codes read from the organization. (Default: no cache)

    .OUTPUTS
    System.Int32. Solution component type code.

    .EXAMPLE
    $type = Get-XrmSolutionComponentType -XrmClient $xrmClient -LogicalName "connectionreference";
    Add-XrmSolutionComponent -XrmClient $xrmClient -SolutionUniqueName "MySolution" -ComponentId $referenceId -ComponentType $type;

    .EXAMPLE
    $cache = @{};
    $viewType = Get-XrmSolutionComponentType -XrmClient $xrmClient -LogicalName "savedquery" -Cache $cache;   # 26

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionComponentType.md
#>
function Get-XrmSolutionComponentType {
    [CmdletBinding(DefaultParameterSetName = "LogicalName")]
    [OutputType([int])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ParameterSetName = "LogicalName")]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogicalName,

        [Parameter(Mandatory = $true, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

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
        $byLogicalName = ($PSCmdlet.ParameterSetName -eq "LogicalName");
        $key = if ($byLogicalName) { $LogicalName.ToLowerInvariant() } else { $Name };
        $cacheKey = "$(if ($byLogicalName) { 'logicalname' } else { 'name' })|$($key.ToLowerInvariant())";
        if ($PSBoundParameters.ContainsKey('Cache') -and $Cache.ContainsKey($cacheKey)) {
            return $Cache[$cacheKey];
        }

        # Solution-aware tables: the organization knows their code
        $query = New-XrmQueryExpression -LogicalName "solutioncomponentdefinition" -Columns "solutioncomponenttype" -TopCount 1;
        $query = $query | Add-XrmQueryCondition -Field $(if ($byLogicalName) { "primaryentityname" } else { "name" }) -Condition Equal -Values $key;
        $definition = $XrmClient | Get-XrmMultipleRecords -Query $query -AsEntity | Select-Object -First 1;
        $componentType = $null;
        if ($definition) {
            $componentType = [int]$definition["solutioncomponenttype"];
        }
        elseif ($byLogicalName) {
            # Classic components are not listed in solutioncomponentdefinition
            $classicTypes = @{
                "entity" = 1; "attribute" = 2; "optionset" = 9; "entityrelationship" = 10; "relationship" = 10; "entitykey" = 14;
                "role" = 20; "savedquery" = 26; "workflow" = 29; "report" = 31; "template" = 36; "duplicaterule" = 44;
                "savedqueryvisualization" = 59; "systemform" = 60; "webresource" = 61; "sitemap" = 62; "connectionrole" = 63;
                "customcontrol" = 66; "fieldsecurityprofile" = 70; "appmodule" = 80; "plugintype" = 90; "pluginassembly" = 91;
                "sdkmessageprocessingstep" = 92; "sdkmessageprocessingstepimage" = 93; "serviceendpoint" = 95;
                "mobileofflineprofile" = 161; "canvasapp" = 300;
            };
            if ($classicTypes.ContainsKey($key)) {
                $componentType = $classicTypes[$key];
            }
        }
        else {
            $table = Get-XrmSolutionComponentTypeTableInternal;
            $match = $table.GetEnumerator() | Where-Object { $_.Value -eq $key } | Select-Object -First 1;
            if ($match) {
                $componentType = [int]$match.Key;
            }
        }

        if ($null -eq $componentType) {
            throw "Unknown solution component type for $(if ($byLogicalName) { "table '$LogicalName'" } else { "name '$Name'" }).";
        }
        if ($PSBoundParameters.ContainsKey('Cache')) {
            $Cache[$cacheKey] = $componentType;
        }
        $componentType;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmSolutionComponentType -Alias *;
