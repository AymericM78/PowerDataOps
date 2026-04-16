<#
    .SYNOPSIS
    Validate a saved query (view) in Microsoft Dataverse.

    .DESCRIPTION
    Check if a saved query (view) definition is valid using the ValidateSavedQuery SDK action.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ViewId
    Guid of the savedquery record to validate.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The ValidateSavedQuery response.

    .EXAMPLE
    $result = Test-XrmView -ViewId $viewId;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/validatesavedquery
#>
function Test-XrmView {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $ViewId
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "ValidateSavedQuery";

        $viewEntityCollection = New-XrmEntityCollection;
        $viewEntity = New-XrmEntity -LogicalName "savedquery";
        $viewEntity.Id = $ViewId;
        $viewEntityCollection.Entities.Add($viewEntity);

        $request | Add-XrmRequestParameter -Name "FetchXml" -Value "" | Out-Null;
        $request | Add-XrmRequestParameter -Name "QueryType" -Value 0 | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmView -Alias *;
