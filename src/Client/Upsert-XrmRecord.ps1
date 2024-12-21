<#
    .SYNOPSIS
    Upsert entity record in Dataverse.

    .Description
    Upsert row (entity record) from Microsoft Dataverse table.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER Record
    Record (row) to Upsert.

    .PARAMETER BypassCustomPluginExecution
    Specify wether involved plugins should be triggered or not during this operation. (Default: False)
#>
function Upsert-XrmRecord {
    [CmdletBinding()]
    [OutputType([Guid])]
    param
    (    
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.Entity]
        $Record,

        [Parameter(Mandatory = $false)]
        [switch]
        $BypassCustomPluginExecution = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {

        $request = New-XrmRequest -Name "Upsert";
        $request | Add-XrmRequestParameter -Name "Target" -Value $Record | Out-Null;
        if ($BypassCustomPluginExecution) {
            $request | Add-XrmRequestParameter -Name "BypassCustomPluginExecution" -Value $true | Out-Null;
        }

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Upsert-XrmRecord -Alias *;