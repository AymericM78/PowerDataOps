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

    .PARAMETER IfExists
    Return $null instead of raising an error when the relationship does not exist.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.RelationshipMetadataBase. The relationship metadata.

    .EXAMPLE
    $rel = Get-XrmRelationship -Name "new_account_contact";

    .EXAMPLE
    if (-not (Get-XrmRelationship -XrmClient $xrmClient -Name "new_account_contact" -IfExists)) { Write-Host "Missing"; }

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRelationship.md
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
        $RetrieveAsIfPublished = $true,

        [Parameter(Mandatory = $false)]
        [switch]
        $IfExists
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.RetrieveRelationshipRequest]::new();
        $request.Name = $Name;
        $request.RetrieveAsIfPublished = $RetrieveAsIfPublished;

        if ($IfExists) {
            try {
                $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request -ErrorAction Stop;
            }
            catch {
                if (Test-XrmNotFoundError -ErrorRecord $_) {
                    return $null;
                }
                throw;
            }
        }
        else {
            $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        }
        if ($null -ne $response) {
            $response.Results["RelationshipMetadata"];
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmRelationship -Alias *;
