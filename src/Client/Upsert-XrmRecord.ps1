<#
    .SYNOPSIS
    Upsert entity record in Dataverse.

    .Description
    Upsert row (entity record) from Microsoft Dataverse table.
    With AsRequest, the UpsertRequest is returned without being sent (for Invoke-XrmBulkRequests or Invoke-XrmParallelRequests).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Record
    Record (row) to Upsert.

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
    Return the UpsertRequest without sending it.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The Upsert response. With AsRequest: Microsoft.Xrm.Sdk.Messages.UpsertRequest.

    .EXAMPLE
    $record = New-XrmEntity -LogicalName "account" -Attributes @{ "name" = "Contoso" };
    Upsert-XrmRecord -Record $record;

    .EXAMPLE
    $request = Upsert-XrmRecord -Record $record -BypassBusinessLogicExecution CustomSync -Tag "sync" -AsRequest;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmRecord.md
#>
function Upsert-XrmRecord {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse], [Microsoft.Xrm.Sdk.Messages.UpsertRequest])]
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
        $request = [Microsoft.Xrm.Sdk.Messages.UpsertRequest]::new();
        $request.Target = $Record;
        $options = Get-XrmRequestOptionsInternal -BoundParameters $PSBoundParameters;
        $request = $request | Set-XrmRequestOptions @options;
        if ($AsRequest) {
            return $request;
        }

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmRecord -Alias *;
