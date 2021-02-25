<#
    .SYNOPSIS
    Display solutions selector
#>
function Select-XrmSolutions {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [Microsoft.PowerShell.Commands.OutputModeOption]
        $OutputMode = "Single",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("solutionid", "uniquename","friendlyname","version","ismanaged","installedon","createdby","publisherid","modifiedon","modifiedby")
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $solutions = Get-XrmSolutions -XrmClient $XrmClient -Columns $Columns;
        $selectedSolutions = $solutions | Out-GridView -OutputMode $OutputMode;
        $selectedSolutions;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Select-XrmSolutions -Alias *;