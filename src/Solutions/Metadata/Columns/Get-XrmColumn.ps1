<#
    .SYNOPSIS
    Retrieve column metadata from Microsoft Dataverse.

    .DESCRIPTION
    Get attribute / column metadata using RetrieveAttributeRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.

    .PARAMETER LogicalName
    Column / Attribute logical name.

    .PARAMETER RetrieveAsIfPublished
    Retrieve metadata as if published. Default: true.

    .PARAMETER MetadataType
    Optional metadata type to enforce, such as [Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata].

    .PARAMETER IfExists
    Return $null instead of throwing when the column does not exist. When MetadataType is provided,
    return $null if the column exists but is not of the expected metadata type.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.AttributeMetadata. The attribute metadata.

    .EXAMPLE
    $column = Get-XrmColumn -EntityLogicalName "account" -LogicalName "name";

    .EXAMPLE
    $column = Get-XrmColumn -EntityLogicalName "account" -LogicalName "new_status" -MetadataType ([Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata]) -IfExists;
#>
function Get-XrmColumn {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.AttributeMetadata])]
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
        [Type]
        $MetadataType,

        [Parameter(Mandatory = $false)]
        [switch]
        $IfExists
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSBoundParameters.ContainsKey('MetadataType') -and -not ([Microsoft.Xrm.Sdk.Metadata.AttributeMetadata]).IsAssignableFrom($MetadataType)) {
            throw "MetadataType must inherit from Microsoft.Xrm.Sdk.Metadata.AttributeMetadata.";
        }

        try {
            $request = [Microsoft.Xrm.Sdk.Messages.RetrieveAttributeRequest]::new();
            $request.EntityLogicalName = $EntityLogicalName;
            $request.LogicalName = $LogicalName;
            $request.RetrieveAsIfPublished = $RetrieveAsIfPublished;

            $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
            $attributeMetadata = $response.Results["AttributeMetadata"];

            if ($PSBoundParameters.ContainsKey('MetadataType') -and -not $MetadataType.IsAssignableFrom($attributeMetadata.GetType())) {
                if ($IfExists) {
                    return $null;
                }

                throw "Column '$EntityLogicalName.$LogicalName' exists but is of type '$($attributeMetadata.GetType().FullName)' instead of '$($MetadataType.FullName)'.";
            }

            $attributeMetadata;
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

Export-ModuleMember -Function Get-XrmColumn -Alias *;
