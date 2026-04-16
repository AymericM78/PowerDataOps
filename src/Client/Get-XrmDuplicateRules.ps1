<#
    .SYNOPSIS
    Retrieve duplicate detection rules from Microsoft Dataverse.

    .DESCRIPTION
    Get duplicaterule records with optional entity filter.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Base entity logical name to filter rules. Optional.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .OUTPUTS
    Microsoft.Xrm.Sdk.Entity[]. Array of duplicaterule records.

    .EXAMPLE
    $rules = Get-XrmDuplicateRules;
    $rules = Get-XrmDuplicateRules -EntityLogicalName "account";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/detect-duplicate-data-with-code
#>
function Get-XrmDuplicateRules {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Entity[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Columns = @("*")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $query = New-XrmQueryExpression -LogicalName "duplicaterule" -Columns $Columns;

        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $query = $query | Add-XrmQueryCondition -Field "baseentityname" -Condition Equal -Values $EntityLogicalName;
        }

        $rules = $XrmClient | Get-XrmMultipleRecords -Query $query;
        $rules;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmDuplicateRules -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmDuplicateRules -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
