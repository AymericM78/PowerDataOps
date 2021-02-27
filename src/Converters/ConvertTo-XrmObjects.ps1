<#
    .SYNOPSIS
    Transform Entity Collection to custom object collection.
#>
function ConvertTo-XrmObjects {
    [CmdletBinding()]
    [OutputType([PsObject[]])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.Entity[]]
        $InputObject
    )
    begin {          
        $records = @();

        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $records += $InputObject | ConvertTo-XrmObject;
    }
    end {
        $records;

        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function ConvertTo-XrmObjects -Alias *;