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

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.AttributeMetadata. The attribute metadata.

    .EXAMPLE
    $column = Get-XrmColumn -EntityLogicalName "account" -LogicalName "name";
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
        $RetrieveAsIfPublished = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.RetrieveAttributeRequest]::new();
        $request.EntityLogicalName = $EntityLogicalName;
        $request.LogicalName = $LogicalName;
        $request.RetrieveAsIfPublished = $RetrieveAsIfPublished;

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response.Results["AttributeMetadata"];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmColumn -Alias *;
