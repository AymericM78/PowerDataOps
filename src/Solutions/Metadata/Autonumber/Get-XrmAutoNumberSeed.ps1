<#
    .SYNOPSIS
    Get the current auto-number seed for a column.

    .DESCRIPTION
    Retrieve the current auto-number seed value for an auto-number column using the GetAutoNumberSeed SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical name of the entity containing the auto-number column.

    .PARAMETER AttributeLogicalName
    Logical name of the auto-number column.

    .OUTPUTS
    System.Int64. The current seed value.

    .EXAMPLE
    $seed = Get-XrmAutoNumberSeed -EntityLogicalName "new_invoice" -AttributeLogicalName "new_invoicenumber";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/create-auto-number-attributes
#>
function Get-XrmAutoNumberSeed {
    [CmdletBinding()]
    [OutputType([long])]
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
        $AttributeLogicalName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "GetAutoNumberSeed";
        $request | Add-XrmRequestParameter -Name "EntityName" -Value $EntityLogicalName | Out-Null;
        $request | Add-XrmRequestParameter -Name "AttributeName" -Value $AttributeLogicalName | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response.Results["AutoNumberSeedValue"];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmAutoNumberSeed -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmAutoNumberSeed -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
