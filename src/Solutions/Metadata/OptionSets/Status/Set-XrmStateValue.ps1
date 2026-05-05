<#
    .SYNOPSIS
    Update a state value in a StateAttributeMetadata attribute.

    .DESCRIPTION
    Update the label and description of a statecode option using the UpdateStateValue SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name that has the statecode attribute.

    .PARAMETER AttributeLogicalName
    Logical name of the state attribute.

    .PARAMETER Value
    The statecode option value to update.

    .PARAMETER Label
    New display label for the statecode option (Label object from New-XrmLabel).

    .PARAMETER Description
    New description label for the statecode option (Label object from New-XrmLabel).

    .PARAMETER DefaultStatusCode
    Default value for the statuscode (status reason) when this statecode is set.

    .PARAMETER MergeLabels
    Whether to merge the current label with existing labels. Default: true.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateStateValue response.

    .EXAMPLE
    Set-XrmStateValue -EntityLogicalName "incident" -AttributeLogicalName "statecode" -Value 0 -Label (New-XrmLabel -Text "Active Case");

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/updatestatevalue
#>
function Set-XrmStateValue {
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
        [ValidateNotNullOrEmpty()]
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
        [int]
        $DefaultStatusCode,

        [Parameter(Mandatory = $false)]
        [bool]
        $MergeLabels = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "UpdateStateValue";
        $request = $request | Add-XrmRequestParameter -Name "EntityLogicalName" -Value $EntityLogicalName;
        $request = $request | Add-XrmRequestParameter -Name "AttributeLogicalName" -Value $AttributeLogicalName;
        $request = $request | Add-XrmRequestParameter -Name "Value" -Value $Value;
        $request = $request | Add-XrmRequestParameter -Name "MergeLabels" -Value $MergeLabels;

        if ($PSBoundParameters.ContainsKey('Label')) {
            $request = $request | Add-XrmRequestParameter -Name "Label" -Value $Label;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $request = $request | Add-XrmRequestParameter -Name "Description" -Value $Description;
        }
        if ($PSBoundParameters.ContainsKey('DefaultStatusCode')) {
            $request = $request | Add-XrmRequestParameter -Name "DefaultStatusCode" -Value $DefaultStatusCode;
        }

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmStateValue -Alias *;

Register-ArgumentCompleter -CommandName Set-XrmStateValue -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
