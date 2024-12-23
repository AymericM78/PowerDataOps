<#
    .SYNOPSIS
    Run solution packager tool.

    .DESCRIPTION
    Pack or unpack given solution file with Solution Packager.

    .PARAMETER SolutionFilePath
    Full path to solution file (.zip).

    .PARAMETER SolutionPackagerExeFilePath
    Full path to solution packager executable. (Default : $PSScriptRoot\bin\SolutionPackager.exe)

    .PARAMETER Action
    The action to perform.
    The action can be either to extract a solution .zip file to a folder, or to pack a folder into a .zip file.

    .PARAMETER PackageType
    The type of package to process. (Default: Both)
    This argument may be omitted in most occasions because the package type can be read from inside the .zip file or component files. 
    When extracting and Both is specified, managed and unmanaged solution .zip files must be present and are processed into a single folder. 
    When packing and Both is specified, managed and unmanaged solution .zip files will be produced from one folder. 

    .PARAMETER FolderPath
    Full path to a folder where solution will be extracted or packed. 
    When extracting, this folder is created and populated with component files. 
    When packing, this folder must already exist and contain previously extracted component files.

    .PARAMETER ErrorLevel
    Indicates the level of logging information to output. (Default: Error)

    .PARAMETER LogFilePath
    Full path to log file. If the file already exists, new logging information is appended to the file.
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
        $SolutionPackagerExeFilePath = "$PSScriptRoot\..\Assemblies\CoreTools\SolutionPackager.exe",

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