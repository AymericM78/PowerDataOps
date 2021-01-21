<#
    .SYNOPSIS
    Retrieve audit partitions
#>
function Get-XrmAuditPartitions {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $request = New-XrmRequest -Name "RetrieveAuditPartitionList";
        $response = $XrmClient | Invoke-XrmRequest -Request $request;

        $AuditPartitionDetailCollection = $response.Results["AuditPartitionDetailCollection"];
        $AuditPartitionDetailCollection | Select-Object PartitionNumber, StartDate, EndDate, Size;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmAuditPartitions  -Alias *;