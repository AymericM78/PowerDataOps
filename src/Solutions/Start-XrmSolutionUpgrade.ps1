<#
    .SYNOPSIS
    Start delete and promote operation for solution.

    .DESCRIPTION 
    Replace managed solution by new one after import.    

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER SolutionUniqueName
    Solution unique name to upgrade.
#>
function Start-XrmSolutionUpgrade {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
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

        $deleteAndPromoteRequest = New-XrmRequest -Name "DeleteAndPromote";
        $deleteAndPromoteRequest | Add-XrmRequestParameter -Name "UniqueName" -Value $SolutionUniqueName | Out-Null;
        
        try {            
            $deleteAndPromoteResponse = $XrmClient | Invoke-XrmRequest -Request $deleteAndPromoteRequest -Async;
            $asyncOperationId = $deleteAndPromoteResponse.AsyncJobId;
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

Register-ArgumentCompleter -CommandName Start-XrmSolutionUpgrade -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}