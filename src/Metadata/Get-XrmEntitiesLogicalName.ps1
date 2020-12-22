<#
    .SYNOPSIS
    Retrieve entities logicalname attribute
#>
function Get-XrmEntitiesLogicalName {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $logicalNames = @();
        $entityMetadata = $XrmClient.GetAllEntityMetadata($true, [Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Default);
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