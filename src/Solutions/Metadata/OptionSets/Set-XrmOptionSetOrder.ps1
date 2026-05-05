<#
    .SYNOPSIS
    Set the display order of option set values.

    .DESCRIPTION
    Reorder the values of a global or local option set using the OrderOption SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER OptionSetName
    Name of the global option set. Use this for global option sets.

    .PARAMETER EntityLogicalName
    Entity logical name for local option sets.

    .PARAMETER AttributeLogicalName
    Attribute logical name for local option sets.

    .PARAMETER Values
    Array of option set integer values in the desired display order.

    .PARAMETER SolutionUniqueName
    Solution unique name for tracking the change. Optional.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The OrderOption response.

    .EXAMPLE
    Set-XrmOptionSetOrder -OptionSetName "new_priority" -Values @(1, 3, 2, 4);
    Set-XrmOptionSetOrder -EntityLogicalName "account" -AttributeLogicalName "new_category" -Values @(100, 200, 300);

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/orderoption
#>
function Set-XrmOptionSetOrder {
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
        [ValidateNotNullOrEmpty()]
        [int[]]
        $Values,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "OrderOption";
        $request | Add-XrmRequestParameter -Name "Values" -Value $Values | Out-Null;

        if ($PSBoundParameters.ContainsKey('OptionSetName')) {
            $request | Add-XrmRequestParameter -Name "OptionSetName" -Value $OptionSetName | Out-Null;
        }
        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $request | Add-XrmRequestParameter -Name "EntityLogicalName" -Value $EntityLogicalName | Out-Null;
        }
        if ($PSBoundParameters.ContainsKey('AttributeLogicalName')) {
            $request | Add-XrmRequestParameter -Name "AttributeLogicalName" -Value $AttributeLogicalName | Out-Null;
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

Export-ModuleMember -Function Set-XrmOptionSetOrder -Alias *;
