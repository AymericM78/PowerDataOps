<#
    .SYNOPSIS
    Assign an SVG webresource icon to a Dataverse table.

    .DESCRIPTION
    Validate a Dataverse SVG webresource, assign it to the table IconVectorName metadata property,
    update the table metadata, and optionally publish the customization.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical name of the Dataverse table that should receive the SVG icon.

    .PARAMETER WebResourceName
    Name of the Dataverse SVG webresource to assign as the table icon.

    .PARAMETER SolutionUniqueName
    Solution unique name context for the metadata update.

    .PARAMETER PublishChanges
    Whether to publish the table customization after updating the icon. Default: true.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.EntityMetadata. The updated table metadata.

    .EXAMPLE
    Set-XrmTableIcon -EntityLogicalName "account" -WebResourceName "new_accounticon.svg";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
#>
function Set-XrmTableIcon {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.EntityMetadata])]
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
        $WebResourceName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [bool]
        $PublishChanges = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $webResource = $XrmClient | Get-XrmRecord -LogicalName 'webresource' -AttributeName 'name' -Value $WebResourceName -Columns 'name', 'webresourcetype';
        if ($null -eq $webResource) {
            throw "Webresource '$WebResourceName' was not found.";
        }

        if ($null -eq $webResource.webresourcetype_Value -or $webResource.webresourcetype_Value.Value -ne 11) {
            throw "Webresource '$WebResourceName' must be an SVG webresource (type 11).";
        }

        $entityMetadata = $XrmClient | Get-XrmEntityMetadata -LogicalName $EntityLogicalName -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity);
        $entityMetadata.IconVectorName = $webResource.name;

        $setTableParameters = @{
            EntityMetadata = $entityMetadata;
        };
        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $setTableParameters['SolutionUniqueName'] = $SolutionUniqueName;
        }

        $updateResponse = $XrmClient | Set-XrmTable @setTableParameters;
        if ($null -eq $updateResponse) {
            throw "Failed to update table '$EntityLogicalName' icon metadata.";
        }

        if ($PublishChanges) {
            $publishXml = "<importexportxml><entities><entity>$EntityLogicalName</entity></entities></importexportxml>";
            $XrmClient | Publish-XrmCustomizations -ParameterXml $publishXml -Async $false;
        }

        $entityMetadata;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmTableIcon -Alias *;