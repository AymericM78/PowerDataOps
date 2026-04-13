<#
    .SYNOPSIS
    Update a solution component.

    .DESCRIPTION
    Update a component in an unmanaged solution using the UpdateSolutionComponent SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Unique name of the solution where the component should exist.

    .PARAMETER ComponentId
    Unique identifier of the component to update.

    .PARAMETER ComponentType
    Component type number (see Get-XrmSolutionComponentName to get name from type number).

    .PARAMETER IncludedComponentSettingsValues
    Array of settings to include in the component update.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateSolutionComponent response.

    .EXAMPLE
    Update-XrmSolutionComponent -SolutionUniqueName "MySolution" -ComponentId $tableId -ComponentType 1 -IncludedComponentSettingsValues @("Setting1");

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/updatesolutioncomponent
#>
function Update-XrmSolutionComponent {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
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
        [Guid]
        $ComponentId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]
        $ComponentType,

        [Parameter(Mandatory = $false)]
        [string[]]
        $IncludedComponentSettingsValues
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "UpdateSolutionComponent";
        $request = $request | Add-XrmRequestParameter -Name "SolutionUniqueName" -Value $SolutionUniqueName;
        $request = $request | Add-XrmRequestParameter -Name "ComponentId" -Value $ComponentId;
        $request = $request | Add-XrmRequestParameter -Name "ComponentType" -Value $ComponentType;

        if ($PSBoundParameters.ContainsKey('IncludedComponentSettingsValues')) {
            $request = $request | Add-XrmRequestParameter -Name "IncludedComponentSettingsValues" -Value $IncludedComponentSettingsValues;
        }

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Update-XrmSolutionComponent -Alias *;

Register-ArgumentCompleter -CommandName Update-XrmSolutionComponent -ParameterName "SolutionUniqueName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}
