<#
    .SYNOPSIS
    Display solutions selector.

    .DESCRIPTION
    Open gridview view all solutions and select one or many.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER OutputMode
    Specify if selector should allow single or multiple items selection. (Default : Single)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, version, ismanaged, installedon, createdby, publisherid, modifiedon, modifiedby)
#>
function Select-XrmSolutions {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [Microsoft.PowerShell.Commands.OutputModeOption]
        $OutputMode = "Single",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("solutionid", "uniquename", "friendlyname", "version", "ismanaged", "installedon", "createdby", "publisherid", "modifiedon", "modifiedby")
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