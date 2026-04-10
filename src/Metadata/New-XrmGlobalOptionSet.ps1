<#
    .SYNOPSIS
    Create a global option set in Microsoft Dataverse.

    .DESCRIPTION
    Create a new global option set using CreateOptionSetRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER OptionSetMetadata
    The OptionSetMetadata object defining the global option set.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the global option set to.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The CreateOptionSet response.

    .EXAMPLE
    $os = [Microsoft.Xrm.Sdk.Metadata.OptionSetMetadata]::new();
    $os.Name = "new_priority";
    $os.DisplayName = New-XrmLabel -Text "Priority";
    $os.IsGlobal = $true;
    $os.OptionSetType = [Microsoft.Xrm.Sdk.Metadata.OptionSetType]::Picklist;
    New-XrmGlobalOptionSet -OptionSetMetadata $os;
#>
function New-XrmGlobalOptionSet {
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
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.CreateOptionSetRequest]::new();
        $request.OptionSet = $OptionSetMetadata;

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

Export-ModuleMember -Function New-XrmGlobalOptionSet -Alias *;
