<#
    .SYNOPSIS
    Set the auto-number seed for a column.

    .DESCRIPTION
    Set the next auto-number value for an auto-number column using the SetAutoNumberSeed SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical name of the entity containing the auto-number column.

    .PARAMETER AttributeLogicalName
    Logical name of the auto-number column.

    .PARAMETER Value
    The new seed value (next number to be assigned).

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The SetAutoNumberSeed response.

    .EXAMPLE
    Set-XrmAutoNumberSeed -EntityLogicalName "new_invoice" -AttributeLogicalName "new_invoicenumber" -Value 10000;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/create-auto-number-attributes
#>
function Set-XrmAutoNumberSeed {
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
        [long]
        $Value
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "SetAutoNumberSeed";
        $request | Add-XrmRequestParameter -Name "EntityName" -Value $EntityLogicalName | Out-Null;
        $request | Add-XrmRequestParameter -Name "AttributeName" -Value $AttributeLogicalName | Out-Null;
        $request | Add-XrmRequestParameter -Name "Value" -Value $Value | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmAutoNumberSeed -Alias *;

Register-ArgumentCompleter -CommandName Set-XrmAutoNumberSeed -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
