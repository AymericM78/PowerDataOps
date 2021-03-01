<#
    .SYNOPSIS
    Restore instance at given time.

    .DESCRIPTION
    Restore a backup of given instance to itself or another instance.

    .PARAMETER SourceInstanceDomainName
    Instance domain name (myinstance => myinstance.crm.dynamics1.com) that you want to restore

    .PARAMETER SourceInstanceDomainName
    Instance domain name (myinstance => myinstance.crm.dynamics1.com) where you want to restore

    .PARAMETER TargetInstanceSecurityGroupId
    AAD Security Group ID to define on target instance to restrict users access

    .PARAMETER RestoreTimeUtc
    Date time in UTC of restore point

    .PARAMETER BackupLabel
    Name of the backup
#>
function Restore-XrmInstance {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]
        $SourceInstanceDomainName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TargetInstanceDomainName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TargetInstanceNewDisplayName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $TargetInstanceSecurityGroupId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [DateTime]
        $RestoreTimeUtc,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $BackupLabel
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
        Assert-XrmAdminConnected;
    }    
    process {

        $restoreTimeUtcValue = "";
        if ($PSBoundParameters.BackupLabel) {
            $backup = Get-XrmBackup -InstanceDomainName $SourceInstanceDomainName -BackupLabel $BackupLabel;
            if (-not $backup) {
                throw "No backup found for label '$BackupLabel'";
            }
            $restoreTimeUtcValue = $backup.backupPointDateTime;
        }
        else {
            if (-not $PSBoundParameters.RestoreTimeUtc) {
                throw "Must use Copy-XrmInstance instead of Restore-XrmInstance!";
            }
            $restoreTimeUtcValue = $RestoreTimeUtc.ToString("yyyy-MM-dd HH:mm:ss");
        }

        $sourceInstance = Get-XrmInstance -Name $SourceInstanceDomainName;
        $restoreRequest = [pscustomobject]@{
            SourceEnvironmentId  = $sourceInstance.Id;
            RestorePointDateTime = $restoreTimeUtcValue
        }

        if ($PSBoundParameters.TargetInstanceDomainName) {
            $targetInstance = Get-XrmInstance -Name $TargetInstanceDomainName;
        }
        else {
            $targetInstance = $sourceInstance;
        }

        if ($PSBoundParameters.TargetInstancNewDisplayName) {
            $restoreRequest | Add-Member -MemberType NoteProperty -Name "TargetEnvironmentName" -Value $TargetInstanceNewDisplayName;
        }
        else {
            $restoreRequest | Add-Member -MemberType NoteProperty -Name "TargetEnvironmentName" -Value $targetInstance.DisplayName;
        }

        if ($PSBoundParameters.TargetInstanceSecurityGroupId) {
            $restoreRequest | Add-Member -MemberType NoteProperty -Name "TargetSecurityGroupId" -Value $TargetInstanceSecurityGroupId;
        }

        $response = Restore-PowerAppEnvironment -EnvironmentName $targetInstance.Id -RestoreToRequestDefinition $restoreRequest -WaitUntilFinished $false;
        if ($response.Code) {
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

Export-ModuleMember -Function Restore-XrmInstance -Alias *;