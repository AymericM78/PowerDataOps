<#
    .SYNOPSIS
    Copy an existing form in Microsoft Dataverse.

    .DESCRIPTION
    Clone a systemform record using the CopySystemForm SDK action. Creates an exact copy of the source form with a new name.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SourceFormId
    Guid of the systemform record to copy.

    .PARAMETER NewName
    Display name for the copied form. Optional. If not provided, Dataverse generates a default name.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the newly created systemform record.

    .EXAMPLE
    $newFormRef = Copy-XrmForm -SourceFormId $existingFormId -NewName "Account Main Form - Copy";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/copysystemform
#>
function Copy-XrmForm {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $SourceFormId,

        [Parameter(Mandatory = $false)]
        [string]
        $NewName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "CopySystemForm";
        $request | Add-XrmRequestParameter -Name "SourceId" -Value $SourceFormId | Out-Null;

        $target = New-XrmEntity -LogicalName "systemform";
        if ($PSBoundParameters.ContainsKey('NewName')) {
            $target["name"] = $NewName;
        }
        $request | Add-XrmRequestParameter -Name "Target" -Value $target | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $newFormId = $response.Results["Id"];

        New-XrmEntityReference -LogicalName "systemform" -Id $newFormId;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Copy-XrmForm -Alias *;
