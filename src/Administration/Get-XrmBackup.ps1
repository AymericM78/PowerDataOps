<#
    .SYNOPSIS
    Retrieve backup infos 
#>
function Get-XrmBackup {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $InstanceDomainName,

        [Parameter(Mandatory = $false)]
        [String]
        $BackupLabel
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
        Assert-XrmAdminConnected;
    }    
    process {
        $instance = Get-XrmInstance -Name $InstanceDomainName;

        $backupData = Get-PowerAppEnvironmentBackups -EnvironmentName $instance.Id;
        $backups = $backupData.value;

        if ($PSBoundParameters.ContainsKey('BackupLabel')) {
            $backup = $backups | Where-Object -Property "label" -EQ -Value $BackupLabel;
            $backup;
        }
        else {
            $backups;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmBackup -Alias *;