<#
    .SYNOPSIS
    Read a connection string from a .NET configuration file.

    .DESCRIPTION
    Read the connectionString of an <add name="..."> entry under <connectionStrings>, in a standard .NET configuration file:
    a connectionStrings.config file (<connectionStrings> root) or an app.config / web.config file (<configuration><connectionStrings>).
    The name is compared without case. Raises an error when the file or the entry does not exist.

    .PARAMETER ConfigPath
    Path of the configuration file.

    .PARAMETER Name
    Name of the connection string entry.

    .OUTPUTS
    System.String. The connection string.

    .EXAMPLE
    $connectionString = Get-XrmConnectionString -ConfigPath ".\connectionStrings.config" -Name "Dev";
    $xrmClient = New-XrmClient -ConnectionString $connectionString;

    .EXAMPLE
    # Show the host of the target environment
    Get-XrmConnectionString -ConfigPath ".\connectionStrings.config" -Name "Dev" | Out-XrmConnectionStringParameter -ParameterName "Url";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmConnectionString.md
#>
function Get-XrmConnectionString {
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigPath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if (-not (Test-Path -Path $ConfigPath -PathType Leaf)) {
            throw "Configuration file '$ConfigPath' not found.";
        }
        [xml]$configuration = Get-Content -Path $ConfigPath -Raw;
        $entries = @($configuration.SelectNodes("//connectionStrings/add"));
        $entry = $entries | Where-Object { $_.GetAttribute("name") -eq $Name } | Select-Object -First 1;
        if (-not $entry) {
            $available = ($entries | ForEach-Object { $_.GetAttribute("name") }) -join ", ";
            throw "Connection string '$Name' not found in '$ConfigPath'. Available: $available.";
        }
        $entry.GetAttribute("connectionString");
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmConnectionString -Alias *;
