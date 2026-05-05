<#
    .SYNOPSIS
    Update an option value in an option set.

    .DESCRIPTION
    Update an existing option value in a global or local option set using the UpdateOptionValue SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER OptionSetName
    Name of the global option set. Required for global option sets.

    .PARAMETER EntityLogicalName
    Table / Entity logical name. Required for local option sets.

    .PARAMETER AttributeLogicalName
    Attribute logical name. Required for local option sets.

    .PARAMETER Value
    Integer value of the option to update.

    .PARAMETER Label
    New display label for the option (Label object from New-XrmLabel).

    .PARAMETER Description
    New description label for the option (Label object from New-XrmLabel).

    .PARAMETER Color
    New hexadecimal color assigned to the option (e.g. "#FF0000").

    .PARAMETER ExternalValue
    New external source value associated with the option.

    .PARAMETER ParentValues
    New parent values associated with the option.

    .PARAMETER MergeLabels
    Whether to keep text defined for languages not included in the Label. Default: true.

    .PARAMETER SolutionUniqueName
    Solution unique name to associate this update with.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateOptionValue response.

    .EXAMPLE
    Set-XrmOptionSetValue -OptionSetName "new_priority" -Value 100000 -Label (New-XrmLabel -Text "Critical Updated");

    .EXAMPLE
    Set-XrmOptionSetValue -EntityLogicalName "account" -AttributeLogicalName "new_category" -Value 100000 -Label (New-XrmLabel -Text "Premium Updated");

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/updateoptionvalue
#>
function Set-XrmOptionSetValue {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [string]
        $OptionSetName,

        [Parameter(Mandatory = $false)]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [string]
        $AttributeLogicalName,

        [Parameter(Mandatory = $true)]
        [int]
        $Value,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Label]
        $Label,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Label]
        $Description,

        [Parameter(Mandatory = $false)]
        [string]
        $Color,

        [Parameter(Mandatory = $false)]
        [string]
        $ExternalValue,

        [Parameter(Mandatory = $false)]
        [int[]]
        $ParentValues,

        [Parameter(Mandatory = $false)]
        [bool]
        $MergeLabels = $true,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "UpdateOptionValue";

        if ($PSBoundParameters.ContainsKey('OptionSetName')) {
            $request = $request | Add-XrmRequestParameter -Name "OptionSetName" -Value $OptionSetName;
        }
        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $request = $request | Add-XrmRequestParameter -Name "EntityLogicalName" -Value $EntityLogicalName;
        }
        if ($PSBoundParameters.ContainsKey('AttributeLogicalName')) {
            $request = $request | Add-XrmRequestParameter -Name "AttributeLogicalName" -Value $AttributeLogicalName;
        }
        $request = $request | Add-XrmRequestParameter -Name "Value" -Value $Value;
        if ($PSBoundParameters.ContainsKey('Label')) {
            $request = $request | Add-XrmRequestParameter -Name "Label" -Value $Label;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $request = $request | Add-XrmRequestParameter -Name "Description" -Value $Description;
        }
        if ($PSBoundParameters.ContainsKey('Color')) {
            $request = $request | Add-XrmRequestParameter -Name "Color" -Value $Color;
        }
        if ($PSBoundParameters.ContainsKey('ExternalValue')) {
            $request = $request | Add-XrmRequestParameter -Name "ExternalValue" -Value $ExternalValue;
        }
        if ($PSBoundParameters.ContainsKey('ParentValues')) {
            $request = $request | Add-XrmRequestParameter -Name "ParentValues" -Value $ParentValues;
        }
        $request = $request | Add-XrmRequestParameter -Name "MergeLabels" -Value $MergeLabels;
        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $request = $request | Add-XrmRequestParameter -Name "SolutionUniqueName" -Value $SolutionUniqueName;
        }

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmOptionSetValue -Alias *;

Register-ArgumentCompleter -CommandName Set-XrmOptionSetValue -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
