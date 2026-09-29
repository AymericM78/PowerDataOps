<#
    .SYNOPSIS
    Create entity record in Microsoft Dataverse.

    .Description
    Add a new row in Microsoft Dataverse table and return created ID (Uniqueidentifier).
    With AsRequest, the CreateRequest is returned without being sent (for Invoke-XrmBulkRequests or Invoke-XrmParallelRequests).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Record
    Record information to add. (Entity)

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
    Return the CreateRequest without sending it.

    .OUTPUTS
    Guid. Newly created record identified. With AsRequest: Microsoft.Xrm.Sdk.Messages.CreateRequest.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $account = New-XrmEntity -LogicalName "account" -Attributes @{
        "name" = "Contoso";
        "revenue" = New-XrmMoney -Value 123456.78;
        "industrycode" = New-XrmOptionSetValue -Value 37;
    }
    $account.Id = Add-XrmRecord -XrmClient $xrmClient -Record $account;

    .EXAMPLE
    $requests = $accounts | ForEach-Object { Add-XrmRecord -Record $_ -BypassBusinessLogicExecution CustomSync, CustomAsync -AsRequest };
    Invoke-XrmBulkRequests -XrmClient $xrmClient -Requests $requests;

    .LINK
    Samples: https://github.com/AymericM78/PowerDataOps/blob/main/documentation/samples/Working%20with%20data.md
#>
function Add-XrmRecord {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Guid], [Microsoft.Xrm.Sdk.Messages.CreateRequest])]
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
        $request = [Microsoft.Xrm.Sdk.Messages.CreateRequest]::new();
        $request.Target = $Record;
        $options = Get-XrmRequestOptionsInternal -BoundParameters $PSBoundParameters;
        $request = $request | Set-XrmRequestOptions @options;
        if ($AsRequest) {
            return $request;
        }

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        # Skipped by -WhatIf, or failed (the error is already written)
        if ($null -eq $response) {
            return;
        }
        $id = $response.Results["id"];
        $id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmRecord -Alias *;
