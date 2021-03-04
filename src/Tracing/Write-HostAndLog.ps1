<#
    .SYNOPSIS
    Display message and output to file.

    .DESCRIPTION 
    Log given message to console with predefined color or level and output it to execution log.
    Execution log is created at module load and is kept in module temp folder.

    .PARAMETER Message
    Message to display and log.

    .PARAMETER ForegroundColor
    Specify color to display in console.
    
    .PARAMETER NoNewline
    Indicates if carriage return is added to current line. If no, following message will be display on same line. (default : false = add new line)
    
    .PARAMETER NoTimeStamp
    Indicates if time stamp should not be displayed in output. (Default : false = add time stamp)

    .PARAMETER Level
    Indicates  log verbosity level. (Default : INFO)
    Values : VERB, INFO, WARN, FAIL, SUCCESS
#>
function Write-HostAndLog {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $true)]
        [String] 
        $Message,

        [Parameter(Mandatory = $False)]
        [ConsoleColor] $ForegroundColor,

        [Parameter(Mandatory = $False)]
        [switch] $NoNewline,

        [Parameter(Mandatory = $False)]
        [switch] $NoTimeStamp,		

        [Parameter(Mandatory = $False)]
        [ValidateSet("VERB", "INFO", "WARN", "FAIL", "SUCCESS")]
        [String] $Level = "INFO"
    )
    begin {       
    }    
    process {
	
        if ($NoTimeStamp -eq $false) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss";
            $Message = "[$timestamp]`t$Message";
        }  
    
        if ($null -eq $ForegroundColor) {
            $ForegroundColor = [ConsoleColor]::White;
        }
        else {
            if ($ForegroundColor -eq [ConsoleColor]::Red) {
                $level = "FAIL";
            }
            elseif ($ForegroundColor -eq [ConsoleColor]::Green) {
                $level = "SUCCESS";
            }
            elseif ($ForegroundColor -eq [ConsoleColor]::Yellow) {
                $level = "WARN";
            }
        }
        $logMessage = "[$level] - $Message";    
        
        if ($NoNewline -eq $false) {
            $logMessage += [Environment]::NewLine;
        }
    
        $logMessage | Out-File -FilePath $Global:LogFilePath -Encoding utf8 -Append -Force;
        
        if ($level -eq "VERB") {
            Write-Verbose $Message;
        }
        elseif ($level -eq "INFO") {
            Write-Host $Message -ForegroundColor $ForegroundColor -NoNewline:$NoNewline;
        }
        elseif ($level -eq "SUCCESS") { # TODO : Display Success only is weird
            Write-Host $Message -ForegroundColor $ForegroundColor -NoNewline:$NoNewline;
            
            if ($env:SYSTEM_TEAMPROJECT) {                
                Write-Host "##vso[task.complete result=Succeeded;] $Message";
            }
        }
        elseif ($level -eq "WARN") {
            Write-Host $Message -ForegroundColor Yellow -NoNewline:$NoNewline;
            if ($env:SLACKURL) {
                Write-XrmMessageToSlack -Message "[$level] $Message";
            }
            if ($env:SYSTEM_TEAMPROJECT) {                
                Write-Host "##vso[task.LogIssue type=warning;] $Message";
            }
        }
        elseif ($level -eq "FAIL") {
            Write-Host $Message -ForegroundColor Red -NoNewline:$NoNewline;
            if ($env:SLACKURL) {
                Write-XrmMessageToSlack -Message "<!channel> [$level] $Message";
            }
            if ($env:SYSTEM_TEAMPROJECT) {                
                Write-Host "##vso[task.LogIssue type=error;] $Message";
            }
        }
    }
    end {
    }    
}

Export-ModuleMember -Function Write-HostAndLog -Alias *;