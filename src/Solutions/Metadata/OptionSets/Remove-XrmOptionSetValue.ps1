<#
    .SYNOPSIS
    Delete an option value from an option set.

    .DESCRIPTION
    Delete an option value from a global or local option set using the DeleteOptionValue SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER OptionSetName
    Name of the global option set. Required for global option sets.

    .PARAMETER EntityLogicalName
    Table / Entity logical name. Required for local option sets.

    .PARAMETER AttributeLogicalName
    Attribute logical name. Required for local option sets.

    .PARAMETER Value
    Integer value of the option to delete.

    .PARAMETER SolutionUniqueName
    Solution unique name associated with this option value.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteOptionValue response.

    .EXAMPLE
    Remove-XrmOptionSetValue -OptionSetName "new_priority" -Value 100000;

    .EXAMPLE
    Remove-XrmOptionSetValue -EntityLogicalName "account" -AttributeLogicalName "new_category" -Value 100000;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/deleteoptionvalue
#>
function Remove-XrmOptionSetValue {
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
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "DeleteOptionValue";

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

Export-ModuleMember -Function Remove-XrmOptionSetValue -Alias *;

Register-ArgumentCompleter -CommandName Remove-XrmOptionSetValue -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
