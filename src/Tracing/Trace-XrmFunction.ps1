<#
    .SYNOPSIS
    Output verbose information about function call.

    .DESCRIPTION
    Core module method to trace information and measure calls performance.

    .PARAMETER Name
    Called function name.

    .PARAMETER Stage
    Indicate when tracung is called from function : Start or Stop.

    .PARAMETER Parameters
    List of arguments provided to function.

    .PARAMETER StopWatch
    StopWath object initialized during first function call in order to measure overall duration.
#>
function Trace-XrmFunction {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Start", "Stop")]
        [String]
        $Stage,

        [Parameter()]
        [object[]]
        $Parameters,

        [Parameter()]
        [System.Diagnostics.Stopwatch]
        $StopWatch
    )
    process {

        # Performance tuning
        $verbose = $VerbosePreference -ne 'SilentlyContinue';
        if (-not $verbose) {
            return;
        }

        $message = "[$Name]`t";
        if ($Stage -eq "Start") {
            $message += "Function started";
        }
        elseif ($Stage -eq "Stop") {
            $message += "Function stopped";  
            
            if ($StopWatch) {
                $message += "`t(Elapsed=$($StopWatch.Elapsed.TotalMilliseconds) ms)";
            }
        }
        else {
            $message += "Function $Stage";   
        }
        Write-HostAndLog -Message $message -Level "VERB" -ForegroundColor Gray;

        if ($Parameters) {
            ($Parameters).Keys | ForEach-Object {
                $value = (Get-Variable -Name $_ -ErrorAction SilentlyContinue).Value;
                if ($value.length -gt 0) {
                    Write-HostAndLog -Message  "[$Name]`t>`tParam : $($_) => $($value)" -Level "VERB" -ForegroundColor DarkGray;
                }
            }
        }
    }
}

Export-ModuleMember -Function Trace-XrmFunction -Alias *;