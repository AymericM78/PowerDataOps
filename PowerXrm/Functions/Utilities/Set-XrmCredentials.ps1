<#
    .SYNOPSIS
    Initialize PSCredential object from given login and password.
#>
function Set-XrmCredentials {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCredential])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Login,

        [Parameter(Mandatory = $true)]
        [String]
        $Password
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $securePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force;
        $credentials = New-Object System.Management.Automation.PSCredential($Login, $securePassword);
        $credentials;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmCredentials -Alias *;