<#
    .SYNOPSIS
    Retrieve entities logicalname attribute.

    .DESCRIPTION
    Get list of columns / attribute logical names from given entity / table.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.
#>
function Get-XrmAttributesLogicalName {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]   
        [ArgumentCompleter( { Get-XrmEntitiesLogicalName })]
        [String]
        $EntityLogicalName
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $logicalNames = @();
        # TODO : CrmServiceClient to ServiceClient migration.
        $attributeMetadata = $XrmClient.GetAllAttributesForEntity($EntityLogicalName);
        $attributeMetadata | ForEach-Object {
            $logicalNames += $_.LogicalName;
        }   
        $logicalNames | Sort-Object;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmAttributesLogicalName -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmAttributesLogicalName -ParameterName "LogicalName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}