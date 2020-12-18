<#
    .SYNOPSIS
    Copy instance to another.
#>
function Copy-XrmInstance {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]
        $SourceInstanceDomainName,

        [Parameter(Mandatory=$true)]
        [String]
        $TargetInstanceDomainName,

        [Parameter(Mandatory=$true)]
        [ValidateSet("FullCopy", "MinimalCopy")]
        [String]
        $CopyType
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
        Assert-XrmAdminConnected;
    }    
    process {    
        $sourceInstance = Get-XrmInstance -Name $SourceInstanceDomainName;
        $targetInstance = Get-XrmInstance -Name $TargetInstanceDomainName;

        $copyToRequest = [pscustomobject]@{
                SourceEnvironmentId = $sourceInstance.Id
                TargetEnvironmentName = $targetInstance.DisplayName
                CopyType = $CopyType
        }

        $response = Copy-PowerAppEnvironment -EnvironmentName $targetInstance.Id -CopyToRequestDefinition $copyToRequest;
        if($response.Code)
        {
            throw "$($response.Error.code) : $($response.Error.message)";
        }
        $operationStatusUrl = $response.Headers["Operation-Location"];
        Watch-XrmOperation -OperationUrl $operationStatusUrl;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Copy-XrmInstance -Alias *;