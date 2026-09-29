<#
    .SYNOPSIS
    Execute Organization Request.

    .Description
    Send request to Microsoft Dataverse for execution.
    Supports -WhatIf and -Confirm for the requests that write: a read request (Retrieve*, WhoAmI, Export*...) always runs, a write request runs only if ShouldProcess allows it (with -WhatIf, it is skipped and $null is returned).
    Every write of the module goes through this cmdlet, so -WhatIf given to any module cmdlet reaches the writes it makes.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Request
    Organization request to execute.

    .PARAMETER Async
    Indicates if request should be run in background. Request must supports asynchronous execution. (Default: false = run synchronously)

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The response ($null when a write is skipped by -WhatIf).

    .EXAMPLE
    $response = $xrmClient | Invoke-XrmRequest -Request (New-XrmRequest -Name "WhoAmI");

    .EXAMPLE
    # Show what would be written, without writing
    $xrmClient | Invoke-XrmRequest -Request $deleteRequest -WhatIf;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmRequest.md
#>
function Invoke-XrmRequest {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low")]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.OrganizationRequest]
        $Request,

        [Parameter(Mandatory = $false)]
        [Switch]
        $Async
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        if ($Async) {
            $innerRequest = $Request
            $Request = New-Object -TypeName Microsoft.Xrm.Sdk.Messages.ExecuteAsyncRequest;
            $Request.Request = $innerRequest;
        }

        if (-not (Test-XrmReadOnlyRequestInternal -Request $Request)) {
            $target = $Request.RequestName;
            if ($Request.Parameters.Contains("Target")) {
                $targetValue = $Request.Parameters["Target"];
                if ($targetValue -is [Microsoft.Xrm.Sdk.Entity] -or $targetValue -is [Microsoft.Xrm.Sdk.EntityReference]) {
                    $target = if ($targetValue.Id -eq [Guid]::Empty) { "$($targetValue.LogicalName) (new)" } else { "$($targetValue.LogicalName) $($targetValue.Id)" };
                }
            }
            elseif ($Request.Parameters.Contains("Requests")) {
                $target = "$($Request.Parameters["Requests"].Count) requests";
            }
            else {
                # Metadata and solution messages name their subject in other parameters
                $subject = @("EntityLogicalName", "LogicalName", "SchemaName", "Name", "UniqueName", "SolutionUniqueName", "ComponentId", "JobName") | Where-Object { $Request.Parameters.Contains($_) -and $null -ne $Request.Parameters[$_] } | ForEach-Object { "$_ = $($Request.Parameters[$_])" };
                if ($subject) {
                    $target = ($subject -join ", ");
                }
            }
            if (-not $PSCmdlet.ShouldProcess($target, $Request.RequestName)) {
                return $null;
            }
        }

        $response = Protect-XrmCommand -ScriptBlock { $XrmClient.Execute($Request) };
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Invoke-XrmRequest -Alias *;
