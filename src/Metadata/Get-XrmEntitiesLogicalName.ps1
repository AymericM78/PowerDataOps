<#
    .SYNOPSIS
    Retrieve entities logicalname

    .DESCRIPTION
    Get list of entity / table logical names.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
#>
function Get-XrmEntitiesLogicalName {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $logicalNames = @();
        $entityMetadata = Get-XrmAllEntityMetadata -XrmClient $XrmClient -Filter "Entity";
        $entityMetadata | ForEach-Object {
            $logicalNames += $_.LogicalName;
        }   
        $logicalNames | Sort-Object;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmEntitiesLogicalName -Alias *;