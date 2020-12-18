<#
    .SYNOPSIS
    Remove entity record in CRM.
#>
function Remove-XrmRecord {
    [CmdletBinding()]
    param
    (    
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
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

        [Parameter(Mandatory=$false)]
        [switch]
        $BypassCustomPluginExecution = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {

        if(-not ($PSBoundParameters.ContainsKey('Record'))) {
            $Record = New-XrmEntity -LogicalName $LogicalName -Id $Id;
        }

        $request = New-XrmRequest -Name "Delete";
        $request | Add-XrmRequestParameter -Name "Target" -Value $Record.ToEntityReference() | Out-Null;
        if($BypassCustomPluginExecution)
        {
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