<#
    .SYNOPSIS
    Initialize OptionSetValue object instance.
#>
function New-XrmOptionSetValue {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.OptionSetValue")]
    param
    (        
        [Parameter(Mandatory = $true)]
        [int]
        $Value
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $optionSetValue = New-Object -TypeName "Microsoft.Xrm.Sdk.OptionSetValue";
        $optionSetValue.Value = $Value;

        [Microsoft.Xrm.Sdk.OptionSetValue] $optionSetValue;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmOptionSetValue -Alias *;