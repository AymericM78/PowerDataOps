<#
    .SYNOPSIS
    Extract parameter value from connectionstring.
    
    .DESCRIPTION
    Output connection string parameter value.

    .PARAMETER ConnectionString
    Connection string.

    .PARAMETER ParameterName
    Parameter name.

    .PARAMETER RaiseErrorIfMising
    If parameter is not found, throw an exception.
#>
function Out-XrmConnectionStringParameter {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [String]
        $ConnectionString,

        [Parameter(Mandatory = $true)]
        [String]
        $ParameterName,

        [Parameter(Mandatory = $false)]
        [Switch]
        $RaiseErrorIfMising
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        if (-not $ConnectionString.Contains($ParameterName)) {
            if ($RaiseErrorIfMising) {
                throw "Parameter '$ParameterName' is not in given connectionstring!";
            }
            return $null;
        }

        $startIndex = $ConnectionString.IndexOf("$($ParameterName)=");
        if($startIndex -lt 0)
        {
            return $null;
        }
        $stopIndex = $ConnectionString.IndexOf(";", $startIndex);
        
        $value = $ConnectionString;
        if ($stopIndex -ne -1) {
            $value = $value.Remove($stopIndex);
        }
        $value = $value.Substring($startIndex);
        $value = $value.Replace("$($ParameterName)=", "");
        
        $value;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Out-XrmConnectionStringParameter -Alias *;