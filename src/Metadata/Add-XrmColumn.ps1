<#
    .SYNOPSIS
    Create a new column in Microsoft Dataverse.

    .DESCRIPTION
    Add a new attribute / column to a table using CreateAttributeRequest.
    Use typed constructors such as New-XrmStringColumn, New-XrmBooleanColumn,
    New-XrmIntegerColumn, New-XrmDecimalColumn, New-XrmDoubleColumn,
    New-XrmMoneyColumn, New-XrmDateColumn, New-XrmChoiceColumn,
    New-XrmMultiChoiceColumn, New-XrmFileColumn, New-XrmImageColumn,
    New-XrmMemoColumn, and New-XrmAutoNumberColumn to build the
    AttributeMetadata object.

    Relationship-based lookups require specialized SDK messages and should use
    Add-XrmOneToManyRelationship or Add-XrmPolymorphicLookup instead of
    Add-XrmColumn.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.

    .PARAMETER Attribute
    The AttributeMetadata object defining the column.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the column to.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The CreateAttribute response.

    .EXAMPLE
    $attr = [Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]::new();
    $attr.LogicalName = "new_code";
    $attr.SchemaName = "new_Code";
    $attr.DisplayName = New-XrmLabel -Text "Code";
    $attr.MaxLength = 50;
    Add-XrmColumn -EntityLogicalName "account" -Attribute $attr;

    .EXAMPLE
    $attr = New-XrmBooleanColumn -LogicalName "new_enabled" -SchemaName "new_Enabled" -DisplayName "Enabled" -DefaultValue $true;
    Add-XrmColumn -EntityLogicalName "account" -Attribute $attr;

    .LINK
    https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns
#>
function Add-XrmColumn {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
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
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.AttributeMetadata]
        $Attribute,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($Attribute -is [Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata]) {
            throw "LookupAttributeMetadata cannot be created with Add-XrmColumn. New-XrmLookupColumn only builds metadata for relationship-based lookup creation. Use Add-XrmOneToManyRelationship for a single-target lookup or Add-XrmPolymorphicLookup for a multi-target lookup.";
        }

        $request = [Microsoft.Xrm.Sdk.Messages.CreateAttributeRequest]::new();
        $request.EntityName = $EntityLogicalName;
        $request.Attribute = $Attribute;

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

Export-ModuleMember -Function Add-XrmColumn -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmColumn -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
