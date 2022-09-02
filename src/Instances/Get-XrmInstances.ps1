<#
    .SYNOPSIS
    Retrieve instances collection.

    .DESCRIPTION
    Get Microsoft Dataverse instance object collection according to current user rights.
#>
function Get-XrmInstances {
    [CmdletBinding()]
    param
    (        
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);        
    }    
    process {
        
        $xrmInstances = @();
      
        if (-not $Global:XrmContext.IsAdminConnected) {
            throw "You are not connected! Please use Connect-XrmAdmin command before."
        }

        if ($Global:XrmContext.IsAdminConnected) {
            $environments = Get-AdminPowerAppEnvironment;
            $environments | ForEach-Object {          
                $internalProperties = $_.Internal.properties;
                $metadata = $_.Internal.properties.linkedEnvironmentMetadata;

                $xrmInstance = New-XrmInstance; 
                $xrmInstance.Id = $_.EnvironmentName;
                $xrmInstance.Name = $metadata.domainName;
                $xrmInstance.UniqueName = $metadata.uniqueName;
                $xrmInstance.DisplayName = $_.DisplayName;
                $url = $metadata.instanceUrl;
                if ($url) {
                    $xrmInstance.Url = $url.TrimEnd('/');
                }
                $xrmInstance.ApiUrl = $metadata.instanceApiUrl;
                $xrmInstance.Location = $_.Location;
                $xrmInstance.DataCenter = $internalProperties.azureRegionHint;
                $xrmInstance.Sku = $internalProperties.environmentSku;
                $xrmInstance.Type = $metadata.type;
                $xrmInstance.Version = $metadata.version;
                $xrmInstance.BaseLanguage = $metadata.baseLanguage;
                $xrmInstance.State = $metadata.instanceState;
                $xrmInstance.CreationTemplates = $metadata.creationTemplates;
                $xrmInstance.ParentConnection = $null;

                $xrmInstance.ConnectionString = $xrmInstance | Out-XrmConnectionString;
                $xrmInstances += $xrmInstance;
            }            
        }
        $xrmInstances | Sort-Object -Property DisplayName;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmInstances -Alias *;