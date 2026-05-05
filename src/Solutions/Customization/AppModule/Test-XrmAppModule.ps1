<#
    .SYNOPSIS
    Validate a model-driven app.

    .DESCRIPTION
    Check a model-driven app for missing dependencies using the ValidateApp SDK function.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleId
    Guid of the appmodule to validate.

    .OUTPUTS
    PSCustomObject. Validation result with ValidationSuccess (bool) and ValidationIssueList (array).

    .EXAMPLE
    $result = Test-XrmAppModule -AppModuleId $appId;
    if (-not $result.ValidationSuccess) { $result.ValidationIssueList | Format-Table; }

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/validateapp
#>
function Test-XrmAppModule {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $AppModuleId
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "ValidateApp";
        $request | Add-XrmRequestParameter -Name "AppModuleId" -Value $AppModuleId | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response.Results["AppValidationResponse"];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmAppModule -Alias *;
