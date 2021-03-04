<#
    .SYNOPSIS
    Initialize EntityCollection object instance.

    .DESCRIPTION
    Get new Entity Collection object from entities array.

    .PARAMETER Entities
    Entities array.
#>
function New-XrmEntityCollection {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.EntityCollection")]
    param
    (        
        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.Entity[]]
        $Entities
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $entityCollection = New-Object -TypeName "Microsoft.Xrm.Sdk.EntityCollection";      
        foreach ($entity in $Entities) {
            $entityCollection.Entities.Add($entity) | Out-Null;
        }

        Write-Output $entityCollection -NoEnumerate;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmEntityCollection -Alias *;