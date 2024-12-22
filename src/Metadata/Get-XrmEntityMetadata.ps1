<#
    .SYNOPSIS
    Retrieve entity metadata

    .DESCRIPTION
    Get entity / table metadata.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalName
    Table / Entity logical name.

    .PARAMETER Filter
    Filter to apply on metadata.

    .PARAMETER RetrieveAsIfPublished
    Retrieve metadata as if published.
#>
function Get-XrmEntityMetadata {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient, 
        
        [Parameter(Mandatory = $true)]
        [string]
        $LogicalName = "",

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.EntityFilters]
        $Filter = [Microsoft.Xrm.Sdk.Metadata.EntityFilters]::All,

        [Parameter(Mandatory = $false)]
        [bool]
        $RetrieveAsIfPublished = $true

    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        $request = [Microsoft.Xrm.Sdk.Messages.RetrieveEntityRequest]::new();
        $request.EntityFilters = $Filter;
        $request.LogicalName = $LogicalName;
        $request.RetrieveAsIfPublished = $RetrieveAsIfPublished;

        $response = Invoke-XrmRequest -XrmClient $XrmClient  -Request $request;

        $metadata = $response.Results["EntityMetadata"];
        $metadata;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmEntityMetadata -Alias *;