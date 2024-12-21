<#
    .SYNOPSIS
    Execute Organization Request.

    .Description
    Send request to Microsoft Dataverse for execution.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER Request
    Organization request to execute.

    .PARAMETER Async
    Indicates if request should be run in background. Request must supports asynchronous execution. (Default: false = run synchronously)
#>
function Invoke-XrmRequest {
    [CmdletBinding()]
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

        $response = Protect-XrmCommand -ScriptBlock { $XrmClient.Execute($Request) };
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Invoke-XrmRequest -Alias *;