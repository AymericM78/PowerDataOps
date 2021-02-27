<#
    .SYNOPSIS
    Run solution packager tool
#>
function Invoke-XrmSolutionPackager {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionFilePath,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [String]
        $SolutionPackagerExeFilePath = "$PSScriptRoot\bin\SolutionPackager.exe",

        [Parameter(Mandatory = $true)]
        [ValidateSet("Extract", "Pack")]
        [String]
        $Action,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Unmanaged", "Managed", "Both")]
        [String]
        $PackageType = "Both",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FolderPath,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Off", "Error", "Warning", "Info", "Both", "Verbose")]
        [String]
        $ErrorLevel = "Error",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogFilePath = "$($env:TEMP)\SolutionPackager.log"

    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        $solutionPackagerOuput = "";
        if ($Action -eq "Extract") {
            $solutionPackagerOuput = & "$SolutionPackagerExeFilePath" /action:$Action /zipfile:"$SolutionFilePath" /folder:"$FolderPath" /clobber /allowWrite:Yes /allowDelete:Yes /errorlevel:$ErrorLevel /nologo;
        }
        elseif ($Action -eq "Pack") {
            $solutionPackagerOuput = & "$SolutionPackagerExeFilePath" /action:$Action /zipfile:"$SolutionFilePath" /folder:"$FolderPath" /packagetype:$PackageType /errorlevel:$ErrorLevel /log:$LogFilePath /nologo;
        }
        $solutionPackagerOuput;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Invoke-XrmSolutionPackager -Alias *;