<#
    .SYNOPSIS
    Set the state and status of a record.

    .DESCRIPTION
    Update the statecode and statuscode of a Dataverse record using Update-XrmRecord.
    With AsRequest, the UpdateRequest is returned without being sent (for Invoke-XrmBulkRequests or Invoke-XrmParallelRequests).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RecordReference
    Entity reference of the target record.

    .PARAMETER StateCode
    State code value to set (e.g., 0 = Active, 1 = Inactive).

    .PARAMETER StatusCode
    Status code value to set. Must be valid for the given state code.

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
    Microsoft.Xrm.Sdk.EntityReference. The record reference. With AsRequest: Microsoft.Xrm.Sdk.Messages.UpdateRequest.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $accountRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
    Set-XrmRecordState -XrmClient $xrmClient -RecordReference $accountRef -StateCode 1 -StatusCode 2;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmRecordState.md
#>
function Set-XrmRecordState {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference], [Microsoft.Xrm.Sdk.Messages.UpdateRequest])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RecordReference,

        [Parameter(Mandatory = $true)]
        [int]
        $StateCode,

        [Parameter(Mandatory = $true)]
        [int]
        $StatusCode,

        [Parameter(Mandatory = $false)]
        [switch]
        $BypassCustomPluginExecution,

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
        $record = New-XrmEntity -LogicalName $RecordReference.LogicalName -Id $RecordReference.Id;
        $record.Attributes["statecode"] = New-XrmOptionSetValue -Value $StateCode;
        $record.Attributes["statuscode"] = New-XrmOptionSetValue -Value $StatusCode;

        $options = Get-XrmRequestOptionsInternal -BoundParameters $PSBoundParameters;
        if ($AsRequest) {
            return (Update-XrmRecord -XrmClient $XrmClient -Record $record -AsRequest @options);
        }
        Update-XrmRecord -XrmClient $XrmClient -Record $record @options;
        $RecordReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmRecordState -Alias *;
