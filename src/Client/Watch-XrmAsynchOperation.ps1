<#
    .SYNOPSIS
    Monitor async operation completion.

    .DESCRIPTION
    Poll status from asynchoperation id until its done.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AsyncOperationId
    System job unique identifier.

    .PARAMETER PollingIntervalSeconds
    Delay between each status check.

    .PARAMETER ScriptBlock
    Command to execute during each poll with asyncoperation info.
#>
function Watch-XrmAsynchOperation {
    [CmdletBinding()]
    param
    (  
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory, ValueFromPipeline)]
        [Guid]
        $AsyncOperationId,

        [Parameter(Mandatory = $false)]
        [int]
        $PollingIntervalSeconds = 5,
            
        [Parameter(Mandatory = $false)]
        [scriptblock] 
        $ScriptBlock,

        [Parameter(Mandatory = $false)]
        [int]
        $TimeoutInMinutes = 60
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $retryCount = 0;
        $maxRetries = 10;
        $waitingStatusValue = @(0, 10);
        $completedStatusValue = @(30, 31, 32);
        $completed = $false;
        $startAt = Get-Date;
        
        while (-not $completed) {
            Start-Sleep -Seconds $PollingIntervalSeconds;
            try {
                $asynchOperation = $XrmClient | Get-XrmRecord -LogicalName "asyncoperation" -Id $AsyncOperationId -Columns "statuscode", "message", "friendlymessage";                
            }
            catch {
                $retryCount++;
                if ($retryCount -ge $maxRetries) {
                    throw "Asynch operation '$AsyncOperationId' not found!"
                }
            }            
            
            $waiting = $waitingStatusValue.Contains($asynchOperation.statuscode_value.Value);        
            if($waiting){
                Write-HostAndLog " > Asyncoperation $AsyncOperationId is waiting for execution..." -ForegroundColor Gray;
                $now = Get-Date;
                if(($now - $startAt).TotalMinutes -gt $TimeoutInMinutes){
                    throw "Operation reach timeout ($TimeoutInMinutes min)!";
                }
            }
            else {
                if ($PSBoundParameters.ScriptBlock) {
                    Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $asynchOperation;
                }
            }

            $completed = $completedStatusValue.Contains($asynchOperation.statuscode_value.Value);
            if (-not $completed) {
                $completed = (-not [string]::IsNullOrWhiteSpace($asynchOperation.friendlymessage));
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Watch-XrmAsynchOperation -Alias *;