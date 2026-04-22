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
    New-XrmOneToManyRelationship or New-XrmPolymorphicLookup instead of
    New-XrmColumn.

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
    New-XrmColumn -EntityLogicalName "account" -Attribute $attr;

    .EXAMPLE
    $attr = New-XrmBooleanColumn -LogicalName "new_enabled" -SchemaName "new_Enabled" -DisplayName "Enabled" -DefaultValue $true;
    New-XrmColumn -EntityLogicalName "account" -Attribute $attr;

    .LINK
    https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns
#>
function New-XrmColumn {
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

Export-ModuleMember -Function New-XrmColumn -Alias *;

Register-ArgumentCompleter -CommandName New-XrmColumn -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
