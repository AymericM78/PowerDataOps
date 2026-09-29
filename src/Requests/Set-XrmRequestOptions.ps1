<#
    .SYNOPSIS
    Set the optional parameters of a Dataverse request.

    .DESCRIPTION
    Add the optional parameters that the platform reads on data operations (Create, Update, Upsert, Delete, ExecuteMultiple items...):
    bypass of custom business logic, bypass of given plug-in steps, no Power Automate trigger, no duplicate detection, tag shared with plug-ins.
    Only the options given are set; a value already present on the request is replaced. Returns the request, for pipeline chaining.
    Bypassing business logic requires the prvBypassCustomBusinessLogic privilege (or prvBypassCustomPlugins for BypassCustomPluginExecution).

    .PARAMETER Request
    Organization request to complete.

    .PARAMETER BypassCustomPluginExecution
    Legacy bypass of synchronous custom plug-ins (BypassCustomPluginExecution parameter). Prefer BypassBusinessLogicExecution.

    .PARAMETER BypassBusinessLogicExecution
    Custom business logic to bypass: CustomSync (synchronous plug-ins and real-time workflows), CustomAsync (asynchronous plug-ins and workflows), or both.

    .PARAMETER BypassBusinessLogicExecutionStepIds
    Ids of the plug-in steps (sdkmessageprocessingstep) to bypass.

    .PARAMETER SuppressCallbackRegistrationExpanderJob
    Do not trigger the Power Automate flows registered on the operation.

    .PARAMETER SuppressDuplicateDetection
    Do not run the duplicate detection rules.

    .PARAMETER Tag
    Value shared with the plug-ins through the execution context (SharedVariables["tag"]).

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationRequest. The request, for pipeline chaining.

    .EXAMPLE
    $request = New-XrmRequest -Name "Create" | Add-XrmRequestParameter -Name "Target" -Value $record;
    $request = $request | Set-XrmRequestOptions -BypassBusinessLogicExecution CustomSync, CustomAsync -SuppressCallbackRegistrationExpanderJob -Tag "migration";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/optional-parameters
#>
function Set-XrmRequestOptions {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationRequest])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.OrganizationRequest]
        $Request,

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
        $Tag
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($BypassCustomPluginExecution) {
            $Request.Parameters["BypassCustomPluginExecution"] = $true;
        }
        if ($PSBoundParameters.ContainsKey('BypassBusinessLogicExecution')) {
            $Request.Parameters["BypassBusinessLogicExecution"] = (@($BypassBusinessLogicExecution | Select-Object -Unique) -join ",");
        }
        if ($PSBoundParameters.ContainsKey('BypassBusinessLogicExecutionStepIds')) {
            $Request.Parameters["BypassBusinessLogicExecutionStepIds"] = (@($BypassBusinessLogicExecutionStepIds | ForEach-Object { $_.ToString() }) -join ",");
        }
        if ($SuppressCallbackRegistrationExpanderJob) {
            $Request.Parameters["SuppressCallbackRegistrationExpanderJob"] = $true;
        }
        if ($SuppressDuplicateDetection) {
            $Request.Parameters["SuppressDuplicateDetection"] = $true;
        }
        if ($PSBoundParameters.ContainsKey('Tag')) {
            $Request.Parameters["tag"] = $Tag;
        }
        $Request;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmRequestOptions -Alias *;
