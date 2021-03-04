<#
    .SYNOPSIS
    Add folder in given path if it doesn't exists.

    .DESCRIPTION
    Create given folder if not exist and return sub folder full path.

    .PARAMETER Path
    Folder path where to add given folder.

    .PARAMETER FolderName
    Folder name.

    .PARAMETER CleanIfExists
    If folder already exists, remove existing content. (Default : False)
#>
function Add-XrmFolder {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ })]
        [String]
        $Path,

        [Parameter(Mandatory = $true)]
        [String]
        $FolderName,

        [Switch]
        $CleanIfExists
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $folderPath = [System.IO.Path]::Combine($Path, $FolderName);
        if ($CleanIfExists) {
            if (Test-Path $folderPath) {
                Remove-Item -Recurse -Force $folderPath;
            }
        }
        New-Item -ItemType Directory -Force -Path $folderPath | Out-Null;
        
        $folderPath;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmFolder -Alias *;