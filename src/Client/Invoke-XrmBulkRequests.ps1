<#
    .SYNOPSIS
    Split and Execute Multiple Organization Requests.

    .Description
    Send requests to Microsoft Dataverse for bulk execution.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER Requests
    Array of organization requests to execute.

    .PARAMETER ContinueOnError
    Indicates wether to continue or stop execution if an error occured. (Default: false = Continue)

    .PARAMETER ReturnResponses
    Indicates if response are collected for each request execution. (Default: false = No response)
#>
function Invoke-XrmBulkRequests {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.OrganizationRequest[]]
        $Requests,

        [Parameter(Mandatory = $false)]
        [int]
        $BatchSize = 500,

        [Parameter(Mandatory = $false)]
        [bool]
        $ContinueOnError = $false,

        [Parameter(Mandatory = $false)]
        [bool]
        $ReturnResponses = $false,

        [Parameter(Mandatory = $false)]
        [switch]
        $Quiet = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        [System.Collections.ArrayList] $responses = @();
        $subRequests = Split-XrmCollection -Collection $Requests -Count $BatchSize;
        
        ForEach-ObjectWithProgress -Collection $subRequests -OperationName "Processing requests" -ScriptBlock {
            param($batchs)
            
            # foreach($batchs in $subRequests) {
            if(-not $Quiet){
                Write-HostAndLog -Message " > Processing $($batchs.Count) requests.";   
            }
            $batchResponse = Invoke-XrmBulkRequest -XrmClient $XrmClient -Requests $batchs -ContinueOnError $ContinueOnError -ReturnResponses $ReturnResponses;
            if(-not $ContinueOnError -and $batchResponse.IsFaulted){
                throw "Processing failed!"; 
            }
            if($ReturnResponses -and $batchResponse.Responses){
                $responses.AddRange($batchResponse.Responses);
            }
        }

        return $responses;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Invoke-XrmBulkRequests -Alias *;