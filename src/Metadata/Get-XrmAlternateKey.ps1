<#
    .SYNOPSIS
    Retrieve alternate key metadata from Microsoft Dataverse.

    .DESCRIPTION
    Get entity key metadata using RetrieveEntityKeyRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.

    .PARAMETER LogicalName
    Alternate key logical name.

    .PARAMETER RetrieveAsIfPublished
    Retrieve metadata as if published. Default: true.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.EntityKeyMetadata. The alternate key metadata.

    .EXAMPLE
    $key = Get-XrmAlternateKey -EntityLogicalName "account" -LogicalName "new_accountcode";
#>
function Get-XrmAlternateKey {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.EntityKeyMetadata])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [bool]
        $RetrieveAsIfPublished = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.RetrieveEntityKeyRequest]::new();
        $request.EntityLogicalName = $EntityLogicalName;
        $request.LogicalName = $LogicalName;
        $request.RetrieveAsIfPublished = $RetrieveAsIfPublished;

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response.Results["EntityKeyMetadata"];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmAlternateKey -Alias *;
