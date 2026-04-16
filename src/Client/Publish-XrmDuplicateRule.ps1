<#
    .SYNOPSIS
    Publish a duplicate detection rule.

    .DESCRIPTION
    Publish (activate) a duplicate detection rule using the PublishDuplicateRule SDK action.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER DuplicateRuleReference
    EntityReference of the duplicaterule record to publish.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The PublishDuplicateRule response containing AsyncOperationId.

    .EXAMPLE
    $ruleRef = New-XrmEntityReference -LogicalName "duplicaterule" -Id $ruleId;
    $response = Publish-XrmDuplicateRule -DuplicateRuleReference $ruleRef;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/publishduplicaterule
#>
function Publish-XrmDuplicateRule {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $DuplicateRuleReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "PublishDuplicateRule";
        $request | Add-XrmRequestParameter -Name "DuplicateRuleId" -Value $DuplicateRuleReference.Id | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Publish-XrmDuplicateRule -Alias *;
