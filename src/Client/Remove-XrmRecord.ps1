<#
    .SYNOPSIS
    Remove record from Microsoft Dataverse.

    .Description
    Delete row (entity record) from Microsoft Dataverse table by logicalname + id or by Entity object.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER Record
    Record (row) to delete.
    
    .PARAMETER LogicalName
    Table / Entity logical name..

    .PARAMETER Id
    Row (entity record) unique identifier

    .PARAMETER BypassCustomPluginExecution
    Specify wether involved plugins should be triggered or not during this operation. (Default: False)
#>
function Remove-XrmRecord {
    [CmdletBinding()]
    param
    (    
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.Entity]
        $Record,

        [Parameter(Mandatory = $false)]
        [string]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [Guid]
        $Id,

        [Parameter(Mandatory = $false)]
        [switch]
        $BypassCustomPluginExecution = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {

        if (-not ($PSBoundParameters.ContainsKey('Record'))) {
            $Record = New-XrmEntity -LogicalName $LogicalName -Id $Id;
        }

        $request = New-XrmRequest -Name "Delete";
        $request | Add-XrmRequestParameter -Name "Target" -Value $Record.ToEntityReference() | Out-Null;
        if ($BypassCustomPluginExecution) {
            $request | Add-XrmRequestParameter -Name "BypassCustomPluginExecution" -Value $true | Out-Null;
        }

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Remove-XrmRecord -Alias *;