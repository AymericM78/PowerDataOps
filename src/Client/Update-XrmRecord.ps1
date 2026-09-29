<#
    .SYNOPSIS
    Update entity record in Microsoft Dataverse.

    .Description
    Update row (entity record) from Microsoft Dataverse table.
    With AsRequest, the UpdateRequest is returned without being sent (for Invoke-XrmBulkRequests or Invoke-XrmParallelRequests).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Record
    Record (row) to update.

    .PARAMETER BypassCustomPluginExecution
    Legacy bypass of synchronous custom plug-ins. Prefer BypassBusinessLogicExecution. (Default: False)

    .PARAMETER BypassBusinessLogicExecution
    Custom business logic to bypass: CustomSync, CustomAsync, or both. Requires the prvBypassCustomBusinessLogic privilege.

    .PARAMETER BypassBusinessLogicExecutionStepIds
    Ids of the plug-in steps to bypass.

    .PARAMETER SuppressCallbackRegistrationExpanderJob
    Do not trigger the Power Automate flows registered on the operation.

    .PARAMETER SuppressDuplicateDetection
    Do not run the duplicate detection rules.

    .PARAMETER Tag
    Value shared with the plug-ins (SharedVariables["tag"]).

    .PARAMETER AsRequest
    Return the UpdateRequest without sending it.

    .OUTPUTS
    System.Void. With AsRequest: Microsoft.Xrm.Sdk.Messages.UpdateRequest.

    .EXAMPLE
    $account = New-XrmEntity -LogicalName "account" -Id $accountId -Attributes @{ "name" = "Contoso Ltd" };
    Update-XrmRecord -XrmClient $xrmClient -Record $account -BypassBusinessLogicExecution CustomSync -SuppressCallbackRegistrationExpanderJob;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmRecord.md
#>
function Update-XrmRecord {
    [CmdletBinding()]
    [OutputType([System.Void], [Microsoft.Xrm.Sdk.Messages.UpdateRequest])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.Entity]
        $Record,

        [Parameter(Mandatory = $false)]
        [switch]
        $BypassCustomPluginExecution = $false,

        [Parameter(Mandatory = $false)]
        [ValidateSet("CustomSync", "CustomAsync")]
        [string[]]
        $BypassBusinessLogicExecution,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Guid[]]
        $BypassBusinessLogicExecutionStepIds,

        [Parameter(Mandatory = $false)]
        [switch]
        $SuppressCallbackRegistrationExpanderJob,

        [Parameter(Mandatory = $false)]
        [switch]
        $SuppressDuplicateDetection,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Tag,

        [Parameter(Mandatory = $false)]
        [switch]
        $AsRequest
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.UpdateRequest]::new();
        $request.Target = $Record;
        $options = Get-XrmRequestOptionsInternal -BoundParameters $PSBoundParameters;
        $request = $request | Set-XrmRequestOptions @options;
        if ($AsRequest) {
            return $request;
        }

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Update-XrmRecord -Alias *;
