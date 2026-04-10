<#
    .SYNOPSIS
    Retrieve relationship metadata from Microsoft Dataverse.

    .DESCRIPTION
    Get relationship metadata using RetrieveRelationshipRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Relationship schema name.

    .PARAMETER RetrieveAsIfPublished
    Retrieve metadata as if published. Default: true.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.RelationshipMetadataBase. The relationship metadata.

    .EXAMPLE
    $rel = Get-XrmRelationship -Name "new_account_contact";
#>
function Get-XrmRelationship {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.RelationshipMetadataBase])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [bool]
        $RetrieveAsIfPublished = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.RetrieveRelationshipRequest]::new();
        $request.Name = $Name;
        $request.RetrieveAsIfPublished = $RetrieveAsIfPublished;

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response.Results["RelationshipMetadata"];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmRelationship -Alias *;
