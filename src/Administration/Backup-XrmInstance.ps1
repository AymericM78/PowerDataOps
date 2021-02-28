<#
    .SYNOPSIS
    Backup instance

    .SYNOPSIS
    Add a backup for given instance

    .PARAMETER InstanceDomainName
    Instance domain name (myinstance => myinstance.crm.dynamics1.com)

    .PARAMETER BackupLabel
    Name of the backup

    .PARAMETER BackupDescription
    Backup description
#>
function Backup-XrmInstance {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]
        $InstanceDomainName,

        [Parameter(Mandatory = $true)]
        [String]
        $BackupLabel,

        [Parameter(Mandatory = $false)]
        [String]
        $BackupDescription
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
        Assert-XrmAdminConnected;
    }    
    process {    
        $instance = Get-XrmInstance -Name $InstanceDomainName;
        $backupRequest = [pscustomobject]@{
            Label = $BackupLabel
            Notes = $BackupDescription
        }

        Backup-PowerAppEnvironment -EnvironmentName $instance.Id -BackupRequestDefinition $backupRequest;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Backup-XrmInstance -Alias *;