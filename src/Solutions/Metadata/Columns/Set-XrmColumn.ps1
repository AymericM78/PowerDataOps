<#
    .SYNOPSIS
    Update a column in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing attribute / column metadata using UpdateAttributeRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.

    .PARAMETER Attribute
    The AttributeMetadata object with updated properties.

    .PARAMETER SolutionUniqueName
    Solution unique name context for the update.

    .PARAMETER MergeLabels
    Whether to merge labels. Default: true.

    .PARAMETER IsAuditEnabled
    Whether auditing is enabled on the column. When specified, overrides the value set on the AttributeMetadata.
    
    .PARAMETER EnableForInteractiveExperience
    Enables the column for interactive dashboards (sets IsGlobalFilterEnabled and IsSortableEnabled).

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateAttribute response.

    .EXAMPLE
    $attr = Get-XrmColumn -EntityLogicalName "account" -LogicalName "new_code";
    $attr.DisplayName = New-XrmLabel -Text "Project Code";
    Set-XrmColumn -EntityLogicalName "account" -Attribute $attr;
#>
function Set-XrmColumn {
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
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [bool]
        $MergeLabels = $true,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsAuditEnabled,

        [Parameter(Mandatory = $false)]
        [switch]
        $EnableForInteractiveExperience
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSBoundParameters.ContainsKey('IsAuditEnabled')) {
            $Attribute.IsAuditEnabled = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($IsAuditEnabled);
        }

        if ($EnableForInteractiveExperience.IsPresent) {
            $Attribute.IsGlobalFilterEnabled = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($true);
            $Attribute.IsSortableEnabled = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($true);
        }

        $request = [Microsoft.Xrm.Sdk.Messages.UpdateAttributeRequest]::new();
        $request.EntityName = $EntityLogicalName;
        $request.Attribute = $Attribute;
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

Export-ModuleMember -Function Set-XrmColumn -Alias *;

Register-ArgumentCompleter -CommandName Set-XrmColumn -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
