<#
    .SYNOPSIS
    Push Dataverse Instance data to a Az DevOps variable group.
#>
function Add-XrmDevOpsVariableGroup {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        $XrmInstance
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $body = '{
            "variables": {
                "ConnectionString": {
                    "value": "[#ConnectionString#]"
                }
            },
            "type": "Vsts",
            "name": "[#Name#]",
            "description": ""
        }';
        $body = $body.Replace("[#ConnectionString#]", $XrmInstance.ConnectionString);
        $body = $body.Replace("[#Name#]", $XrmInstance.Name);

        Invoke-XrmDevOpsApi -RelativeApiUrl "/distributedtask/variablegroups" -Method POST -Body $body | Out-Null;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmDevOpsVariableGroup -Alias *;