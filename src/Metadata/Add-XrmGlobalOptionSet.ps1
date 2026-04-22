<#
    .SYNOPSIS
    Create a global option set in Microsoft Dataverse.

    .DESCRIPTION
    Create a new global option set using CreateOptionSetRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER OptionSetMetadata
    The OptionSetMetadata object defining the global option set.

    .PARAMETER Name
    Global option set name when creating from a typed option definition list.

    .PARAMETER DisplayName
    Global option set display label when creating from a typed option definition list.

    .PARAMETER Options
    Global option set options when creating from a typed option definition list.

    .PARAMETER Description
    Optional global option set description label when creating from a typed option definition list.

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
    Add-XrmGlobalOptionSet -OptionSetMetadata $os;

    .EXAMPLE
    $options = @(
        (New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Low") -Color "#CDDAFD"),
        (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "High") -Color "#FCE1E4")
    );
    Add-XrmGlobalOptionSet -Name "new_priority" -DisplayName (New-XrmLabel -Text "Priority") -Options $options;
#>
function Add-XrmGlobalOptionSet {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByMetadata')]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase]
        $OptionSetMetadata,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByDefinition')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByDefinition')]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Label]
        $DisplayName,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByDefinition')]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.OptionMetadata[]]
        $Options,

        [Parameter(Mandatory = $false, ParameterSetName = 'ByDefinition')]
        [Microsoft.Xrm.Sdk.Label]
        $Description,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $metadataToCreate = $OptionSetMetadata;
        if ($PSCmdlet.ParameterSetName -eq 'ByDefinition') {
            $optionSet = [Microsoft.Xrm.Sdk.Metadata.OptionSetMetadata]::new();
            $optionSet.Name = $Name;
            $optionSet.DisplayName = $DisplayName;
            $optionSet.IsGlobal = $true;
            $optionSet.OptionSetType = [Microsoft.Xrm.Sdk.Metadata.OptionSetType]::Picklist;

            if ($PSBoundParameters.ContainsKey('Description')) {
                $optionSet.Description = $Description;
            }

            foreach ($option in $Options) {
                $optionSet.Options.Add($option);
            }

            $metadataToCreate = $optionSet;
        }

        $request = [Microsoft.Xrm.Sdk.Messages.CreateOptionSetRequest]::new();
        $request.OptionSet = $metadataToCreate;

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

Export-ModuleMember -Function Add-XrmGlobalOptionSet -Alias *;
