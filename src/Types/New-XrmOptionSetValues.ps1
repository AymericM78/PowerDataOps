<#
    .SYNOPSIS
    Initialize OptionSetValueCollection object instance.
#>
function New-XrmOptionSetValues {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.OptionSetValueCollection")]
    param
    (        
        [Parameter(Mandatory = $true)]
        [int[]]
        $Values
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $optionSetValues = New-Object System.Collections.Generic.List[Microsoft.Xrm.Sdk.OptionSetValue];        
        foreach ($value in $Values) {
            $optionSetValue = (New-XrmOptionSetValue -Value $value);
            $optionSetValues.Add($optionSetValue) | Out-Null;
        }
        
        $optionSetCollection = New-Object -TypeName "Microsoft.Xrm.Sdk.OptionSetValueCollection";
        $optionSetCollection.AddRange($optionSetValues) | Out-Null;

        Write-Output $optionSetCollection -NoEnumerate;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmOptionSetValues -Alias *;