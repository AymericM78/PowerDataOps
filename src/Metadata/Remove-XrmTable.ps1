<#
    .SYNOPSIS
    Delete a table from Microsoft Dataverse.

    .DESCRIPTION
    Delete an entity / table using DeleteEntityRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalName
    Table / Entity logical name to delete.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteEntity response.

    .EXAMPLE
    Remove-XrmTable -LogicalName "new_project";
#>
function Remove-XrmTable {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogicalName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.DeleteEntityRequest]::new();
        $request.LogicalName = $LogicalName;

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmTable -Alias *;

Register-ArgumentCompleter -CommandName Remove-XrmTable -ParameterName "LogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
