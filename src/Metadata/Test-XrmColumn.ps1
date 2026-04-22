<#
    .SYNOPSIS
    Verify whether a Dataverse column exists.

    .DESCRIPTION
    Return $true when a column exists on the specified table. Optionally enforce a specific
    metadata type such as [Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata].

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.

    .PARAMETER LogicalName
    Column / Attribute logical name.

    .PARAMETER MetadataType
    Optional metadata type to enforce.

    .PARAMETER RetrieveAsIfPublished
    Retrieve metadata as if published. Default: true.

    .OUTPUTS
    System.Boolean.

    .EXAMPLE
    Test-XrmColumn -EntityLogicalName "account" -LogicalName "name";

    .EXAMPLE
    Test-XrmColumn -EntityLogicalName "account" -LogicalName "new_status" -MetadataType ([Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata]);
#>
function Test-XrmColumn {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
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
        [Type]
        $MetadataType,

        [Parameter(Mandatory = $false)]
        [bool]
        $RetrieveAsIfPublished = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $params = @{
            XrmClient            = $XrmClient;
            EntityLogicalName    = $EntityLogicalName;
            LogicalName          = $LogicalName;
            RetrieveAsIfPublished = $RetrieveAsIfPublished;
            IfExists             = $true;
        };
        if ($PSBoundParameters.ContainsKey('MetadataType')) {
            $params['MetadataType'] = $MetadataType;
        }

        $attributeMetadata = Get-XrmColumn @params;
        [bool]($null -ne $attributeMetadata);
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmColumn -Alias *;

Register-ArgumentCompleter -CommandName Test-XrmColumn -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}