<#
    .SYNOPSIS
    Enable or disable admin mode on given instance
#>
function Set-XrmInstanceMode {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]
        $InstanceDomainName,

        [Parameter(Mandatory=$true)]
        [ValidateSet("Normal", "AdminOnly")]
        [string]
        $Mode
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
        Assert-XrmAdminConnected;
    }    
    process {    
        $instance = Get-XrmInstance -Name $InstanceDomainName;
        
        $runtimeState = "Enabled";
        switch ($Mode)
        {
            "Normal" { $runtimeState = "Enabled" }
            "AdminOnly" { $runtimeState = "AdminMode" }
        }

        $response = Set-AdminPowerAppEnvironmentRuntimeState -EnvironmentName $instance.Id -RuntimeState $runtimeState -WaitUntilFinished $true;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmInstanceMode -Alias *;