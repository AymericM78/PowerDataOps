<#
    .SYNOPSIS
    Insert a new option value in an option set.

    .DESCRIPTION
    Insert a new option value in a global or local option set using the InsertOptionValue SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER OptionSetName
    Name of the global option set. Required for global option sets.

    .PARAMETER EntityLogicalName
    Table / Entity logical name. Required for local option sets.

    .PARAMETER AttributeLogicalName
    Attribute logical name. Required for local option sets.

    .PARAMETER Value
    Integer value for the new option. If not provided, the system assigns one.

    .PARAMETER Label
    Display label for the option (Label object from New-XrmLabel).

    .PARAMETER Description
    Description label for the option (Label object from New-XrmLabel).

    .PARAMETER Color
    Hexadecimal color assigned to the option (e.g. "#FF0000").

    .PARAMETER SolutionUniqueName
    Solution unique name to associate this option value with.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The InsertOptionValue response.

    .EXAMPLE
    Add-XrmOptionSetValue -OptionSetName "new_priority" -Value 100000 -Label (New-XrmLabel -Text "Critical");

    .EXAMPLE
    Add-XrmOptionSetValue -EntityLogicalName "account" -AttributeLogicalName "new_category" -Value 100000 -Label (New-XrmLabel -Text "Premium");

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/insertoptionvalue
#>
function Add-XrmOptionSetValue {
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

        [Parameter(Mandatory = $false)]
        [int]
        $Value,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
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
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "InsertOptionValue";

        if ($PSBoundParameters.ContainsKey('OptionSetName')) {
            $request = $request | Add-XrmRequestParameter -Name "OptionSetName" -Value $OptionSetName;
        }
        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $request = $request | Add-XrmRequestParameter -Name "EntityLogicalName" -Value $EntityLogicalName;
        }
        if ($PSBoundParameters.ContainsKey('AttributeLogicalName')) {
            $request = $request | Add-XrmRequestParameter -Name "AttributeLogicalName" -Value $AttributeLogicalName;
        }
        if ($PSBoundParameters.ContainsKey('Value')) {
            $request = $request | Add-XrmRequestParameter -Name "Value" -Value $Value;
        }
        $request = $request | Add-XrmRequestParameter -Name "Label" -Value $Label;
        if ($PSBoundParameters.ContainsKey('Description')) {
            $request = $request | Add-XrmRequestParameter -Name "Description" -Value $Description;
        }
        if ($PSBoundParameters.ContainsKey('Color')) {
            $request = $request | Add-XrmRequestParameter -Name "Color" -Value $Color;
        }
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

Export-ModuleMember -Function Add-XrmOptionSetValue -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmOptionSetValue -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
