<#
    .SYNOPSIS
    Retrieve a global option set from Microsoft Dataverse.

    .DESCRIPTION
    Get global option set metadata using RetrieveOptionSetRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Global option set name.

    .PARAMETER RetrieveAsIfPublished
    Retrieve metadata as if published. Default: true.

    .PARAMETER IfExists
    Return $null instead of throwing when the global option set does not exist.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase. The global option set metadata.

    .EXAMPLE
    $optionSet = Get-XrmGlobalOptionSet -Name "new_status";
#>
function Get-XrmGlobalOptionSet {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase])]
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
        try {
            $request = [Microsoft.Xrm.Sdk.Messages.RetrieveOptionSetRequest]::new();
            $request.Name = $Name;
            $request.RetrieveAsIfPublished = $RetrieveAsIfPublished;

            $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
            $response.Results["OptionSetMetadata"];
        }
        catch {
            if ($IfExists -and (Test-XrmNotFoundError -ErrorRecord $_)) {
                return $null;
            }

            throw;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmGlobalOptionSet -Alias *;
