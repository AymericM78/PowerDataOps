<#
    .SYNOPSIS
    Create a bulk delete job.

    .DESCRIPTION
    Submit a BulkDeleteRequest to asynchronously delete records matching a given query expression.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Query
    QueryExpression defining the records to delete.

    .PARAMETER JobName
    Name of the bulk delete job. (Default: "Bulk Delete")

    .PARAMETER SendEmailNotification
    Whether to send email notification when the job completes. (Default: false)

    .PARAMETER ToRecipients
    Array of system user entity references to receive email notification. (Default: empty)

    .PARAMETER CCRecipients
    Array of system user entity references to receive email notification in CC. (Default: empty)

    .PARAMETER RecurrencePattern
    Recurrence pattern for the bulk delete job. Empty string for one-time execution. (Default: "")

    .PARAMETER StartDateTime
    UTC date/time at which the bulk delete job should start. (Default: now)

    .PARAMETER SourceImportId
    Optional source import unique identifier to scope the deletion.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. BulkDelete response containing JobId.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $query = New-XrmQueryExpression -LogicalName "account" -Columns "accountid";
    $query | Add-XrmQueryCondition -Field "statecode" -Condition Equal -Values @(1);
    $response = Add-XrmBulkDelete -XrmClient $xrmClient -Query $query -JobName "Clean inactive accounts";
    $jobId = $response.Results["JobId"];
#>
function Add-XrmBulkDelete {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.Query.QueryExpression]
        $Query,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $JobName = "Bulk Delete",

        [Parameter(Mandatory = $false)]
        [bool]
        $SendEmailNotification = $false,

        [Parameter(Mandatory = $false)]
        [Guid[]]
        $ToRecipients = @(),

        [Parameter(Mandatory = $false)]
        [Guid[]]
        $CCRecipients = @(),

        [Parameter(Mandatory = $false)]
        [string]
        $RecurrencePattern = "",

        [Parameter(Mandatory = $false)]
        [datetime]
        $StartDateTime = [datetime]::UtcNow,

        [Parameter(Mandatory = $false)]
        [Guid]
        $SourceImportId = [Guid]::Empty
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $request = New-XrmRequest -Name "BulkDelete";
        $request | Add-XrmRequestParameter -Name "QuerySet" -Value @($Query) | Out-Null;
        $request | Add-XrmRequestParameter -Name "JobName" -Value $JobName | Out-Null;
        $request | Add-XrmRequestParameter -Name "SendEmailNotification" -Value $SendEmailNotification | Out-Null;
        $request | Add-XrmRequestParameter -Name "ToRecipients" -Value $ToRecipients | Out-Null;
        $request | Add-XrmRequestParameter -Name "CCRecipients" -Value $CCRecipients | Out-Null;
        $request | Add-XrmRequestParameter -Name "RecurrencePattern" -Value $RecurrencePattern | Out-Null;
        $request | Add-XrmRequestParameter -Name "StartDateTime" -Value $StartDateTime | Out-Null;
        if ($SourceImportId -ne [Guid]::Empty) {
            $request | Add-XrmRequestParameter -Name "SourceImportId" -Value $SourceImportId | Out-Null;
        };
        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmBulkDelete -Alias *;
