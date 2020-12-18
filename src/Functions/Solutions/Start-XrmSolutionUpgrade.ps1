<#
    .SYNOPSIS
    Start delete and promote operation for solution.
#>
function Start-XrmSolutionUpgrade {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $deleteAndPromoteRequest = New-XrmRequest -Name "DeleteAndPromote ";
        $deleteAndPromoteRequest | Add-XrmRequestParameter -Name "UniqueName" -Value $SolutionUniqueName | Out-Null;
        
        try 
        {            
            $deleteAndPromoteResponse = $XrmClient | Invoke-XrmRequest -Request $deleteAndPromoteRequest -Async;
            $asyncOperationId =  $deleteAndPromoteResponse.AsyncJobId;
            Watch-XrmAsynchOperation -AsyncOperationId $asyncOperationId;
        }
        catch {
            $errorMessage = $_.Exception.Message;
            Write-HostAndLog "$($MyInvocation.MyCommand.Name) => KO : [Error: $errorMessage]" -ForegroundColor Red -Level FAIL;
            write-progress one one -completed;
            throw $errorMessage;
        }  
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Start-XrmSolutionUpgrade -Alias *;