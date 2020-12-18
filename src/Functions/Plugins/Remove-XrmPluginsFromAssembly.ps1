<#
    .SYNOPSIS
    Remove Plugins Steps and Types From Assembly
#>
function Remove-XrmPluginsFromAssembly {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $AssemblyName = "Plugins"
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        $assembly = Get-XrmRecord -LogicalName "pluginassembly" -AttributeName "name" -Value $AssemblyName;
        if(-not $assembly)
        {
            return;
        }

        $querySteps = New-XrmQueryExpression -LogicalName "sdkmessageprocessingstep";
        $link = $querySteps | Add-XrmQueryLink -ToEntityName "plugintype" -FromAttributeName "eventhandler" -ToAttributeName "plugintypeid"  `
                            | Add-XrmQueryLinkCondition -Field "pluginassemblyid" -Condition Equal -Values $assembly.Id;
        $steps = $XrmClient | Get-XrmMultipleRecords -Query $querySteps;

        if($steps)
        {
            ForEach-ObjectWithProgress -Collection $steps -OperationName "Removing plugin steps from $AssemblyName" -ScriptBlock {
                param($step)

                Remove-XrmRecord -XrmClient $XrmClient -Record $step.Record;
            }
        }

        $queryTypes = New-XrmQueryExpression -LogicalName "plugintype" `
                    | Add-XrmQueryCondition -Field "pluginassemblyid" -Condition Equal -Values $assembly.Id `
                    | Add-XrmQueryCondition -Field "isworkflowactivity" -Condition Equal -Values $false;
        $types = $XrmClient | Get-XrmMultipleRecords -Query $queryTypes;

        if($types)
        {
            ForEach-ObjectWithProgress -Collection $types -OperationName "Removing plugin types from $AssemblyName" -ScriptBlock {
                param($type)

                Remove-XrmRecord -XrmClient $XrmClient -Record $type.Record;
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Remove-XrmPluginsFromAssembly -Alias *;