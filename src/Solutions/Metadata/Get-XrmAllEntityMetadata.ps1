<#
    .SYNOPSIS
    Retrieve all entity metadata

    .DESCRIPTION
    Get list of entity / table metadata.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Filter
    Filter to apply on entities metadata.

    .PARAMETER RetrieveAsIfPublished
    Retrieve metadata as if published.
#>
function Get-XrmAllEntityMetadata {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

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
        
        $metadata = @();

        $request = New-XrmRequest -Name "RetrieveAllEntities";
        $request = $request | Add-XrmRequestParameter -Name "EntityFilters" -Value $Filter;
        $request = $request | Add-XrmRequestParameter -Name "RetrieveAsIfPublished" -Value $RetrieveAsIfPublished;

        $response = Invoke-XrmRequest -XrmClient $XrmClient  -Request $request;

        $metadata = $response.Results["EntityMetadata"];
        $metadata;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmAllEntityMetadata -Alias *;