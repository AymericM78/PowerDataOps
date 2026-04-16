<#
    .SYNOPSIS
    Merge two records in Microsoft Dataverse.

    .DESCRIPTION
    Merge a subordinate record into a target record using the Merge SDK message.
    The subordinate record is deactivated after the merge.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER TargetReference
    EntityReference of the target (surviving) record.

    .PARAMETER SubordinateId
    Guid of the subordinate (merged/deactivated) record.

    .PARAMETER UpdateContent
    Entity object containing attribute values to update on the target record during merge. Optional.

    .PARAMETER PerformParentingChecks
    Whether to check if the parent information is different for the two records. Default: false.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The Merge response.

    .EXAMPLE
    $targetRef = New-XrmEntityReference -LogicalName "account" -Id $targetAccountId;
    Merge-XrmRecord -TargetReference $targetRef -SubordinateId $duplicateAccountId;

    .EXAMPLE
    $update = New-XrmEntity -LogicalName "account" -Attributes @{ "telephone1" = "555-1234" };
    Merge-XrmRecord -TargetReference $targetRef -SubordinateId $duplicateId -UpdateContent $update;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/merge
#>
function Merge-XrmRecord {
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
        $TargetReference,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $SubordinateId,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Entity]
        $UpdateContent,

        [Parameter(Mandatory = $false)]
        [bool]
        $PerformParentingChecks = $false
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "Merge";
        $request | Add-XrmRequestParameter -Name "Target" -Value $TargetReference | Out-Null;
        $request | Add-XrmRequestParameter -Name "SubordinateId" -Value $SubordinateId | Out-Null;
        $request | Add-XrmRequestParameter -Name "PerformParentingChecks" -Value $PerformParentingChecks | Out-Null;

        if ($PSBoundParameters.ContainsKey('UpdateContent')) {
            $request | Add-XrmRequestParameter -Name "UpdateContent" -Value $UpdateContent | Out-Null;
        }
        else {
            $emptyEntity = New-XrmEntity -LogicalName $TargetReference.LogicalName;
            $request | Add-XrmRequestParameter -Name "UpdateContent" -Value $emptyEntity | Out-Null;
        }

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Merge-XrmRecord -Alias *;
