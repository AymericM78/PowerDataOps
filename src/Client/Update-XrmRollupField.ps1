<#
    .SYNOPSIS
    Recalculate a rollup field value.

    .DESCRIPTION
    Force recalculation of a rollup field for a specific record using the CalculateRollupField SDK function.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RecordReference
    EntityReference of the record to recalculate.

    .PARAMETER FieldName
    Logical name of the rollup field.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Entity. The entity with the recalculated rollup field value.

    .EXAMPLE
    $recordRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
    $result = Update-XrmRollupField -RecordReference $recordRef -FieldName "new_totalrevenue";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/calculaterollupfield
#>
function Update-XrmRollupField {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Entity])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RecordReference,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $FieldName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "CalculateRollupField";
        $request | Add-XrmRequestParameter -Name "Target" -Value $RecordReference | Out-Null;
        $request | Add-XrmRequestParameter -Name "FieldName" -Value $FieldName | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response.Results["Entity"];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Update-XrmRollupField -Alias *;
