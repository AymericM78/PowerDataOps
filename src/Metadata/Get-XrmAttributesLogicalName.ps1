<#
    .SYNOPSIS
    Retrieve entities logicalname attribute
#>
function Get-XrmAttributesLogicalName {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
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