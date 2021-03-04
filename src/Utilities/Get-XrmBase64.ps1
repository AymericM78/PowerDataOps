<#
    .SYNOPSIS
    Get base 64 from file content.

    .DESCRIPTION
    Read given file and return its content as base64 content.

    .PARAMETER FilePath
    Full file path.
#>
function Get-XrmBase64 {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [string]
        $FilePath
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $content = [System.IO.File]::ReadAllBytes($FilePath);
        $content64 = [System.Convert]::ToBase64String($content);
        $content64;        
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmBase64 -Alias *;