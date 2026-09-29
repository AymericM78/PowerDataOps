<#
    .SYNOPSIS
    Add Solution Component.

    .DESCRIPTION
    Add given component to specified solution.
    Raises an error that names the component and the solution when the platform refuses the addition.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name where to add component.

    .PARAMETER ComponentId
    Component unique identifier.

    .PARAMETER ComponentType
    Component type number (see Get-XrmSolutionComponentName to get name from type number).

    .PARAMETER DoNotIncludeSubcomponents
    Indicates whether the subcomponents should be excluded. The platform accepts true only for tables (ComponentType 1). (Default : true for a table, false for any other component type)
    
    .PARAMETER AddRequiredComponents
    Gets or sets a value that indicates whether other solution components that are required by the solution component that you are adding should also be added to the unmanaged solution. Required. (Default : false = do not add required components)

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The AddSolutionComponent response.

    .EXAMPLE
    Add-XrmSolutionComponent -SolutionUniqueName "MySolution" -ComponentId $tableId -ComponentType 1;
#>
function Add-XrmSolutionComponent {
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
        [bool]
        $DoNotIncludeSubcomponents,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]
        $AddRequiredComponents = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        if (-not $PSBoundParameters.ContainsKey('DoNotIncludeSubcomponents')) {
            $DoNotIncludeSubcomponents = ($ComponentType -eq 1);
        }

        $addComponentRequest = New-XrmRequest -Name "AddSolutionComponent";
        $addComponentRequest = $addComponentRequest | Add-XrmRequestParameter -Name "SolutionUniqueName" -Value $SolutionUniqueName;
        $addComponentRequest = $addComponentRequest | Add-XrmRequestParameter -Name "ComponentId" -Value $ComponentId;
        $addComponentRequest = $addComponentRequest | Add-XrmRequestParameter -Name "ComponentType" -Value $ComponentType;
        $addComponentRequest = $addComponentRequest | Add-XrmRequestParameter -Name "AddRequiredComponents" -Value $AddRequiredComponents;
        $addComponentRequest = $addComponentRequest | Add-XrmRequestParameter -Name "DoNotIncludeSubcomponents" -Value $DoNotIncludeSubcomponents;

        try {
            $response = $XrmClient | Invoke-XrmRequest -Request $addComponentRequest;
        }
        catch {
            throw [System.InvalidOperationException]::new("Cannot add component '$ComponentId' (type $ComponentType) to solution '$SolutionUniqueName': $($_.Exception.Message)", $_.Exception);
        }
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmSolutionComponent -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmSolutionComponent -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}