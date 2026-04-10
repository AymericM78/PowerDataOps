<#
    .SYNOPSIS
    Update a table in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing entity / table metadata using UpdateEntityRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityMetadata
    The EntityMetadata object with updated properties.

    .PARAMETER SolutionUniqueName
    Solution unique name context for the update.

    .PARAMETER MergeLabels
    Whether to merge labels. Default: true.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateEntity response.

    .EXAMPLE
    $metadata = Get-XrmEntityMetadata -LogicalName "account";
    $metadata.DisplayName = New-XrmLabel -Text "Customer";
    Set-XrmTable -EntityMetadata $metadata;
#>
function Set-XrmTable {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.EntityMetadata]
        $EntityMetadata,

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
        $request = [Microsoft.Xrm.Sdk.Messages.UpdateEntityRequest]::new();
        $request.Entity = $EntityMetadata;
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

Export-ModuleMember -Function Set-XrmTable -Alias *;
