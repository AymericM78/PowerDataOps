<#
    .SYNOPSIS
    Retrieve form records from Microsoft Dataverse.

    .DESCRIPTION
    Get systemform records (forms) filtered by entity logical name and optionally by form type.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name to filter forms. Optional.

    .PARAMETER FormType
    Form type filter (0=Dashboard, 2=Main, 5=Mobile, 6=QuickCreate, 7=QuickView). Optional.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .OUTPUTS
    Microsoft.Xrm.Sdk.Entity[]. Array of systemform records.

    .EXAMPLE
    $forms = Get-XrmForms -EntityLogicalName "account";
    $mainForms = Get-XrmForms -EntityLogicalName "account" -FormType 2;
    $dashboards = Get-XrmForms -FormType 0;
#>
function Get-XrmForms {
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
        [int]
        $FormType,

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
        $query = New-XrmQueryExpression -LogicalName "systemform" -Columns $Columns;

        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $query = $query | Add-XrmQueryCondition -Field "objecttypecode" -Condition Equal -Values $EntityLogicalName;
        }

        if ($PSBoundParameters.ContainsKey('FormType')) {
            $query = $query | Add-XrmQueryCondition -Field "type" -Condition Equal -Values $FormType;
        }

        $forms = $XrmClient | Get-XrmMultipleRecords -Query $query;
        $forms;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmForms -Alias *;
