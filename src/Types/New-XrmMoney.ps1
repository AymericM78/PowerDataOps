<#
    .SYNOPSIS
    Initialize Money object instance.

    .DESCRIPTION
    Get new money object from given decimal value.

    .PARAMETER Value
    Decimal value.
#>
function New-XrmMoney {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.Money")]
    param
    (        
        [Parameter(Mandatory = $true)]
        [decimal]
        $Value
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $moneyValue = New-Object -TypeName "Microsoft.Xrm.Sdk.Money";
        $moneyValue.Value = $Value;

        [Microsoft.Xrm.Sdk.Money] $moneyValue;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmMoney -Alias *;