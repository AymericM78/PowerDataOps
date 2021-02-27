<#
    .SYNOPSIS
    Retrieve instances collection.
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
                $xrmInstance.Url = $metadata.instanceUrl;
                $xrmInstance.ApiUrl = $metadata.instanceApiUrl;
                $xrmInstance.TenantId = [Guid]::Empty;
                $xrmInstance.Location = $_.Location;
                $xrmInstance.DataCenter = $internalProperties.azureRegionHint;
                $xrmInstance.Sku = $internalProperties.environmentSku;
                $xrmInstance.Type = $metadata.type;
                $xrmInstance.Version = $metadata.version;
                $xrmInstance.BaseLanguage = $metadata.baseLanguage;
                $xrmInstance.State = $metadata.instanceState;
                $xrmInstance.CreationTemplates = $metadata.creationTemplates;
                $xrmInstance.ConnectionString = [String]::Empty;
                $xrmInstance.ParentConnection = $null;

                $xrmInstance.ConnectionString = $xrmInstance | Out-XrmConnectionString; # TODO : Handle connectionstring according to auth context
                $xrmInstances += $xrmInstance;
            }            
        }
        elseif ($Global:XrmContext.IsUserConnected) {
            $instances = Get-CrmOrganizations -Credential $Global:XrmContext.CurrentConnection.Credentials -DeploymentRegion $Global:XrmContext.CurrentConnection.Region -OnLineType $Global:XrmContext.CurrentConnection.AuthType;
            
            $instances | ForEach-Object {
                $xrmInstance = New-XrmInstance;
                $xrmInstance.Id = $_.EnviromentId;
                $xrmInstance.Name = $_.UrlHostName;
                $xrmInstance.UniqueName = $_.UniqueName;
                $xrmInstance.DisplayName = $_.FriendlyName;
                $xrmInstance.Url = $_.WebApplicationUrl;
                $xrmInstance.ApiUrl = $_.OrganizationWebAPIUrl;
                $xrmInstance.TenantId = $_.TenantId;

                $xrmInstance.ConnectionString = $xrmInstance | Out-XrmConnectionString; # TODO : Handle connectionstring according to auth context
                $xrmInstances += $xrmInstance;
            }
        }
        else {
            throw "You are not connected! Please use Connect-XrmUser or Connect-XrmAdmin command before."
        }
        $xrmInstances | Sort-Object -Property DisplayName;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmInstances -Alias *;