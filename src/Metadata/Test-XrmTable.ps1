<#
    .SYNOPSIS
    Verify whether a Dataverse table exists.

    .DESCRIPTION
    Return $true when a table/entity metadata record exists for the specified logical name.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalName
    Table / Entity logical name.

    .PARAMETER RetrieveAsIfPublished
    Retrieve metadata as if published. Default: true.

    .OUTPUTS
    System.Boolean.

    .EXAMPLE
    Test-XrmTable -LogicalName "account";
#>
function Test-XrmTable {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [bool]
        $RetrieveAsIfPublished = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $entityMetadata = Get-XrmEntityMetadata -XrmClient $XrmClient -LogicalName $LogicalName -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity) -RetrieveAsIfPublished $RetrieveAsIfPublished -IfExists;
        [bool]($null -ne $entityMetadata);
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmTable -Alias *;

Register-ArgumentCompleter -CommandName Test-XrmTable -ParameterName "LogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}