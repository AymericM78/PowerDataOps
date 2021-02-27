<#
    .SYNOPSIS
    Protect command from API Limit issues.
#>
function Protect-XrmCommand {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $true)]
        [scriptblock] 
        $ScriptBlock,

        [Parameter(Mandatory = $false)]
        [int]
        $Maximum = 0
    )
    begin {       
        $retryCount = 0

        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $result = Invoke-Command -ScriptBlock $ScriptBlock;      
        return $result;    

        # TODO : Retry mechanism to be reviewed
        # do {
        #     $retryCount++;
        #     try {
        #         $result = $ScriptBlock.Invoke();      
        #         return $result;         
        #     } 
        #     catch {                
        #         $delay = [Random]::new().Next(50 * $retryCount);
        #         
        #         # TODO : Exit if error is not a API limit or lock issue
        # 
        #         Write-Error $_.Exception.InnerException.Message -ErrorAction Continue;
        #         Start-Sleep -Seconds ($delay);
        #     }
        # } while ($retryCount -lt $Maximum)
        # 
        # # Throw an error after $Maximum unsuccessful invocations. 
        # # Doesn't need a condition, since the function returns upon successful invocation.
        # throw "Execution failed.";
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Protect-XrmCommand -Alias *;