<#
    .SYNOPSIS
    Remove record from Microsoft Dataverse.

    .Description
    Delete row (entity record) from Microsoft Dataverse table by logicalname + id or by Entity object.
    With AsRequest, the DeleteRequest is returned without being sent (for Invoke-XrmBulkRequests or Invoke-XrmParallelRequests).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Record
    Record (row) to delete.

    .PARAMETER LogicalName
    Table / Entity logical name..

    .PARAMETER Id
    Row (entity record) unique identifier

    .PARAMETER BypassCustomPluginExecution
    Legacy bypass of synchronous custom plug-ins. Prefer BypassBusinessLogicExecution. (Default: False)

    .PARAMETER BypassBusinessLogicExecution
    Custom business logic to bypass: CustomSync, CustomAsync, or both. Requires the prvBypassCustomBusinessLogic privilege.

    .PARAMETER BypassBusinessLogicExecutionStepIds
    Ids of the plug-in steps to bypass.

    .PARAMETER SuppressCallbackRegistrationExpanderJob
    Do not trigger the Power Automate flows registered on the operation.

    .PARAMETER Tag
    Value shared with the plug-ins (SharedVariables["tag"]).

    .PARAMETER AsRequest
    Return the DeleteRequest without sending it.

    .OUTPUTS
    System.Void. With AsRequest: Microsoft.Xrm.Sdk.Messages.DeleteRequest.

    .EXAMPLE
    Remove-XrmRecord -XrmClient $xrmClient -LogicalName "account" -Id $accountId;

    .EXAMPLE
    $requests = $ids | ForEach-Object { Remove-XrmRecord -LogicalName "account" -Id $_ -BypassBusinessLogicExecution CustomSync -AsRequest };

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmRecord.md
#>
function Remove-XrmRecord {
    [CmdletBinding()]
    [OutputType([System.Void], [Microsoft.Xrm.Sdk.Messages.DeleteRequest])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.Entity]
        $Record,

        [Parameter(Mandatory = $false)]
        [string]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [Guid]
        $Id,

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
        if (-not ($PSBoundParameters.ContainsKey('Record'))) {
            $Record = New-XrmEntity -LogicalName $LogicalName -Id $Id;
        }
        $request = [Microsoft.Xrm.Sdk.Messages.DeleteRequest]::new();
        $request.Target = $Record.ToEntityReference();
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

Export-ModuleMember -Function Remove-XrmRecord -Alias *;
