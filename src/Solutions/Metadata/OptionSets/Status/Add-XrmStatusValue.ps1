<#
    .SYNOPSIS
    Insert a new status value (status reason) for a table.

    .DESCRIPTION
    Add a new status reason value to a Status attribute using the InsertStatusValue SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical name of the entity.

    .PARAMETER AttributeLogicalName
    Logical name of the status attribute (typically "statuscode").

    .PARAMETER Label
    Display label for the new status value.

    .PARAMETER StateCode
    The state code (statecode value) this status reason belongs to (e.g. 0 = Active, 1 = Inactive).

    .PARAMETER Value
    Specific integer value for the new status. Optional — auto-assigned by the platform if not specified.

    .PARAMETER LanguageCode
    Language code for the label. Default: 1033 (English).

    .PARAMETER SolutionUniqueName
    Solution unique name for tracking the change. Optional.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The InsertStatusValue response containing the new value.

    .EXAMPLE
    $response = Add-XrmStatusValue -EntityLogicalName "incident" -AttributeLogicalName "statuscode" -Label "Waiting for Customer" -StateCode 0;
    $newValue = $response.Results["NewOptionalValue"];

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/insertstatusvalue
#>
function Add-XrmStatusValue {
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

        [Parameter(Mandatory = $false)]
        [string]
        $AttributeLogicalName = "statuscode",

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Label,

        [Parameter(Mandatory = $true)]
        [int]
        $StateCode,

        [Parameter(Mandatory = $false)]
        [int]
        $Value,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "InsertStatusValue";
        $request | Add-XrmRequestParameter -Name "EntityLogicalName" -Value $EntityLogicalName | Out-Null;
        $request | Add-XrmRequestParameter -Name "AttributeLogicalName" -Value $AttributeLogicalName | Out-Null;
        $request | Add-XrmRequestParameter -Name "Label" -Value (New-XrmLabel -Text $Label -LanguageCode $LanguageCode) | Out-Null;
        $request | Add-XrmRequestParameter -Name "StateCode" -Value $StateCode | Out-Null;

        if ($PSBoundParameters.ContainsKey('Value')) {
            $request | Add-XrmRequestParameter -Name "Value" -Value $Value | Out-Null;
        }
        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $request | Add-XrmRequestParameter -Name "SolutionUniqueName" -Value $SolutionUniqueName | Out-Null;
        }

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmStatusValue -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmStatusValue -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
