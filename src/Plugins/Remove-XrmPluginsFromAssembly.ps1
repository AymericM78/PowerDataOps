<#
    .SYNOPSIS
    Remove Plugins Steps and Types From Assembly.

    .DESCRIPTION
    Uninstall all steps and types from plugin assembly.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER AssemblyName
    Name of assembly where plugin will be removed. (Default : Plugins)
#>
function Remove-XrmPluginsFromAssembly {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
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
        if (-not $assembly) {
            return;
        }        

        $querySteps = New-XrmQueryExpression -LogicalName "sdkmessageprocessingstep" -Columns "name"  | Add-XrmQueryCondition -Field "rank" -Condition GreaterThan -Values 0;
        $link = $querySteps | Add-XrmQueryLink -ToEntityName "plugintype" -FromAttributeName "eventhandler" -ToAttributeName "plugintypeid"  `
            | Add-XrmQueryLinkCondition -Field "pluginassemblyid" -Condition Equal -Values $assembly.Id;
        $steps = $XrmClient | Get-XrmMultipleRecords -Query $querySteps;

        if ($steps) {
            ForEach-ObjectWithProgress -Collection $steps -OperationName "Removing plugin steps from $AssemblyName" -ScriptBlock {
                param($step)

                try {
                    Remove-XrmRecord -XrmClient $XrmClient -Record $step.Record;
                }
                catch {
                    Write-HostAndLog -Message " > Unable to remove plugin step : $($step.name)" -Level WARN;
                }
            }
        }

        $fetchXml = '<fetch version="1.0" output-format="xml-platform" mapping="logical" distinct="true">
                        <entity name="plugintype">
                            <attribute name="plugintypeid" />
                            <filter type="and">
                                <condition attribute="pluginassemblyid" operator="eq" uiname="Plugins" uitype="pluginassembly" value="[AssemblyId]" />
                                <condition attribute="isworkflowactivity" operator="eq" value="0" />
                            </filter>
                            <link-entity name="sdkmessageprocessingstep" from="plugintypeid" to="plugintypeid" link-type="outer" alias="af" />
                            <filter type="and">
                                <condition entityname="af" attribute="plugintypeid" operator="null" />
                            </filter>
                        </entity>
                    </fetch>';
        $fetchXml = $fetchXml.Replace("[AssemblyId]", $assembly.Id);
        $queryTypes = Get-XrmQueryFromFetch -FetchXml $fetchXml;
        $types = $XrmClient | Get-XrmMultipleRecords -Query $queryTypes;

        if ($types) {
            ForEach-ObjectWithProgress -Collection $types -OperationName "Removing plugin types from $AssemblyName" -ScriptBlock {
                param($type)

                try {
                    Remove-XrmRecord -XrmClient $XrmClient -Record $type.Record; 
                }
                catch {
                    Write-HostAndLog -Message " > Unable to remove plugin type : $($type.name)" -Level WARN;
                }
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Remove-XrmPluginsFromAssembly -Alias *;