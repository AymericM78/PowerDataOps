<#
    .SYNOPSIS
    Delete a model-driven app from Microsoft Dataverse.

    .DESCRIPTION
    Remove an appmodule record (model-driven app).
    Publishing an app makes the platform add Dataverse search rows (dvtablesearch) for it: M365_Primary_model_<unique name>, which prevents the app deletion, and new_dvtablesearch_aiplugin_model_<unique name>, which the app deletion leaves behind. These rows are deleted first.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleReference
    EntityReference of the appmodule record to delete.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Remove-XrmAppModule -AppModuleReference $appRef;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmAppModule.md
#>
function Remove-XrmAppModule {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $AppModuleReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if (Test-XrmTable -XrmClient $XrmClient -LogicalName "dvtablesearch") {
            # m365appmoduleid blocks the delete; appmoduleid (no relationship) would stay orphaned
            $query = New-XrmQueryExpression -LogicalName "dvtablesearch" -Columns "name";
            $query.Criteria.FilterOperator = [Microsoft.Xrm.Sdk.Query.LogicalOperator]::Or;
            $query = $query | Add-XrmQueryCondition -Field "m365appmoduleid" -Condition Equal -Values $AppModuleReference.Id;
            $query = $query | Add-XrmQueryCondition -Field "m365appmoduleidsecondary" -Condition Equal -Values $AppModuleReference.Id;
            $query = $query | Add-XrmQueryCondition -Field "appmoduleid" -Condition Equal -Values $AppModuleReference.Id;
            $searchRows = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $query -AsArray;
            foreach ($searchRow in $searchRows) {
                $XrmClient | Remove-XrmRecord -LogicalName "dvtablesearch" -Id $searchRow.Id -IfExists;
            }
        }
        $XrmClient | Remove-XrmRecord -LogicalName "appmodule" -Id $AppModuleReference.Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmAppModule -Alias *;
