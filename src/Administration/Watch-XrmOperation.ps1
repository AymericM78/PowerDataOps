<#
    .SYNOPSIS
    Monitor operation completion.

    .DESCRIPTION
    Poll operation status from given url until its done.

    .PARAMETER OperationUrl
    Operation Url provided when admin operation is invoked.

    .PARAMETER PollingIntervalSeconds
    Delay between each status check.
#>
function Watch-XrmOperation {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $OperationUrl,

        [Parameter(Mandatory = $false)]
        [int]
        $PollingIntervalSeconds = 5
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
        Assert-XrmAdminConnected;
    }    
    process {
        $monitor = $true;
        while ($monitor) {
            Start-Sleep -Seconds $PollingIntervalSeconds;
                
            $operationData = Get-AdminPowerAppOperationStatus -OperationStatusUrl $OperationUrl;
            $operation = $operationData.Internal.Content | ConvertFrom-Json;

            $state = $operation.state.id;

            $monitor = ($state -eq "Running");
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss";

            Write-HostAndLog $timestamp -NoNewline -ForegroundColor Gray;
            Write-HostAndLog " Operation $($operation.type.id): " -NoNewline -ForegroundColor White;
            $stateColor = "Gray";
            switch ($state) {
                "Running" { $stateColor = "Yellow" }
                "Completed" { $stateColor = "Green" }
                "Succeeded" { $stateColor = "Green" }
                "Failed" { $stateColor = "Red" }
            }
            Write-HostAndLog "$state" -NoNewline -ForegroundColor $stateColor;

            Write-HostAndLog " [" -NoNewline -ForegroundColor White;
            foreach ($stage in $operation.stages) {
                Write-HostAndLog "$($stage.name) = " -NoNewline -ForegroundColor White;
                $stageColor = "Gray";
                $stageStatus = $stage.state.id;
                switch ($stageStatus) {
                    "Running" { $stageColor = "Yellow" }
                    "Succeeded" { $stageColor = "Green" }
                    "Completed" { $stageColor = "Green" }
                    "Failed" { $stageColor = "Red" }
                }
                Write-HostAndLog "$stageStatus" -NoNewline -ForegroundColor $stageColor;
                Write-HostAndLog " | " -NoNewline -ForegroundColor White;
            }
            Write-HostAndLog "]" -ForegroundColor White;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Watch-XrmOperation -Alias *;