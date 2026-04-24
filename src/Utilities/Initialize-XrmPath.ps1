<#
    .SYNOPSIS
    Initialize a local file system path.

    .DESCRIPTION
    Create a directory path if it does not exist, or create the parent directory of a file path.

    .PARAMETER Path
    Directory path or file path to initialize.

    .PARAMETER AsFilePath
    Treat the provided path as a file path and initialize only its parent directory.

    .OUTPUTS
    System.String. The initialized path.

    .EXAMPLE
    Initialize-XrmPath -Path "C:\Temp\Exports";

    .EXAMPLE
    Initialize-XrmPath -Path "C:\Temp\Exports\Accounts.xlsx" -AsFilePath;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
#>
function Initialize-XrmPath {
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path,

        [Parameter(Mandatory = $false)]
        [switch]
        $AsFilePath = $false
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $pathToCreate = $Path;
        if ($AsFilePath) {
            $pathToCreate = [System.IO.Path]::GetDirectoryName($Path);
            if ([string]::IsNullOrWhiteSpace($pathToCreate)) {
                return $Path;
            }
        }

        if (-not (Test-Path $pathToCreate)) {
            [void][System.IO.Directory]::CreateDirectory($pathToCreate);
        }

        if ($AsFilePath) {
            $Path;
        }
        else {
            $pathToCreate;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Initialize-XrmPath -Alias *;