<#
    .SYNOPSIS
    Execute Organization Request.
#>
function Invoke-XrmRequest {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
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