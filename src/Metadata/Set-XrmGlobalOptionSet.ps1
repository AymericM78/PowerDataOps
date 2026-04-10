<#
    .SYNOPSIS
    Update a global option set in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing global option set using UpdateOptionSetRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER OptionSetMetadata
    The OptionSetMetadata object with updated properties.

    .PARAMETER SolutionUniqueName
    Solution unique name context for the update.

    .PARAMETER MergeLabels
    Whether to merge labels. Default: true.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateOptionSet response.

    .EXAMPLE
    $os = Get-XrmGlobalOptionSet -Name "new_priority";
    $os.DisplayName = New-XrmLabel -Text "Priority Level";
    Set-XrmGlobalOptionSet -OptionSetMetadata $os;
#>
function Set-XrmGlobalOptionSet {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase]
        $OptionSetMetadata,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [bool]
        $MergeLabels = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.UpdateOptionSetRequest]::new();
        $request.OptionSet = $OptionSetMetadata;
        $request.MergeLabels = $MergeLabels;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $request.Parameters["SolutionUniqueName"] = $SolutionUniqueName;
        }

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmGlobalOptionSet -Alias *;
