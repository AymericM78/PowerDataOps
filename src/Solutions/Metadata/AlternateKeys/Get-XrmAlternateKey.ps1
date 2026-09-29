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

    .PARAMETER IfExists
    Return $null instead of raising an error when the alternate key does not exist.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.EntityKeyMetadata. The alternate key metadata.

    .EXAMPLE
    $key = Get-XrmAlternateKey -EntityLogicalName "account" -LogicalName "new_accountcode";

    .EXAMPLE
    if (-not (Get-XrmAlternateKey -XrmClient $xrmClient -EntityLogicalName "account" -LogicalName "new_accountcode" -IfExists)) { Write-Host "Missing"; }

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAlternateKey.md
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
        $request = [Microsoft.Xrm.Sdk.Messages.RetrieveEntityKeyRequest]::new();
        $request.EntityLogicalName = $EntityLogicalName;
        $request.LogicalName = $LogicalName;
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
            $response.Results["EntityKeyMetadata"];
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmAlternateKey -Alias *;
