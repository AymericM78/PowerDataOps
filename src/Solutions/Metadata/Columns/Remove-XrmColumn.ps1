<#
    .SYNOPSIS
    Delete a column from Microsoft Dataverse.

    .DESCRIPTION
    Delete an attribute / column from a table using DeleteAttributeRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.

    .PARAMETER LogicalName
    Column / Attribute logical name to delete.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteAttribute response.

    .EXAMPLE
    Remove-XrmColumn -EntityLogicalName "account" -LogicalName "new_code";
#>
function Remove-XrmColumn {
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
        $EntityLogicalName,

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
        $request = [Microsoft.Xrm.Sdk.Messages.DeleteAttributeRequest]::new();
        $request.EntityLogicalName = $EntityLogicalName;
        $request.LogicalName = $LogicalName;

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmColumn -Alias *;

Register-ArgumentCompleter -CommandName Remove-XrmColumn -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
