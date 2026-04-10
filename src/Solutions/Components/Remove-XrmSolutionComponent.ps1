<#
    .SYNOPSIS
    Remove a component from an unmanaged solution.

    .DESCRIPTION
    Remove given component from specified unmanaged solution using the RemoveSolutionComponent SDK message.
    This does not delete the component from the environment, it only removes it from the solution.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name from which to remove the component.

    .PARAMETER ComponentId
    Component unique identifier.

    .PARAMETER ComponentType
    Component type number (see Get-XrmSolutionComponentName to get name from type number).

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. SDK response.

    .EXAMPLE
    Remove-XrmSolutionComponent -SolutionUniqueName "contoso_crm" -ComponentId $entityId -ComponentType 1;

    .EXAMPLE
    $components = Get-XrmSolutionComponents -SolutionUniqueName "contoso_crm" -ComponentTypes @(26);
    $components | ForEach-Object {
        Remove-XrmSolutionComponent -SolutionUniqueName "contoso_crm" -ComponentId $_.objectid -ComponentType 26;
    };

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/reference/entities/solutioncomponent
#>
function Remove-XrmSolutionComponent {
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
        $ComponentType
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $removeComponentRequest = New-XrmRequest -Name "RemoveSolutionComponent";
        $removeComponentRequest = $removeComponentRequest | Add-XrmRequestParameter -Name "SolutionUniqueName" -Value $SolutionUniqueName;
        $removeComponentRequest = $removeComponentRequest | Add-XrmRequestParameter -Name "ComponentId" -Value $ComponentId;
        $removeComponentRequest = $removeComponentRequest | Add-XrmRequestParameter -Name "ComponentType" -Value $ComponentType;

        $response = $XrmClient | Invoke-XrmRequest -Request $removeComponentRequest;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmSolutionComponent -Alias *;

Register-ArgumentCompleter -CommandName Remove-XrmSolutionComponent -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}
