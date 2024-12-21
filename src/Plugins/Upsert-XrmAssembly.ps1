<#
    .SYNOPSIS
    Create or update plugin / workflow assembly.

    .DESCRIPTION
    Add new or update existing assembly content from local dll file.    

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER AssemblyPath
    Full file path to dll.

    .PARAMETER SolutionUniqueName
    Microsoft Dataverse solution unique name where to add new assembly.

    .PARAMETER IsolationMode
    Specify if assembly will be deploy in sandbox or not. (Default = 2 | 1 = Not sandboxed, 2 = Sandbox)

    .PARAMETER SourceType
    Specify where assembly will be stored. (Default = 0 | 0 = Database, 1 = Disk, 2 = Normal (OnPremise), 3 = AzureWebApp)
#>
function Upsert-XrmAssembly {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [string]
        $AssemblyPath,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [int]
        $IsolationMode = 2, # Sandbox

        [Parameter(Mandatory = $false)]
        [int]
        $SourceType = 0 # Database
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        
        $assemblyFile = [System.Reflection.Assembly]::Load([System.IO.File]::ReadAllBytes($AssemblyPath));
        $assemblyProperties = $assemblyFile.GetName().FullName.Split(",= ".ToCharArray(), [StringSplitOptions]::RemoveEmptyEntries);
        $assemblyShortName = $assemblyProperties[0];
        $assemblyContent = Get-XrmBase64 -FilePath $AssemblyPath;

        $existingAssembly = Get-XrmRecord -XrmClient $XrmClient -LogicalName "pluginassembly" -AttributeName "name" -Value $assemblyShortName;
        if (-not $existingAssembly) {
            $assemblyRecord = New-XrmEntity -LogicalName "pluginassembly" -Attributes @{
                name           = $assemblyProperties[0]
                version        = $assemblyProperties[2]
                culture        = $assemblyProperties[4]
                publickeytoken = $assemblyProperties[6]
                content        = $assemblyContent
                sourcetype     = (New-XrmOptionSetValue -Value $SourceType)
                isolationmode  = (New-XrmOptionSetValue -Value $IsolationMode)
            };
            $assemblyRecord.Id = $XrmClient | Add-XrmRecord -Record $assemblyRecord;            
        }
        else {
            $assemblyRecord = New-XrmEntity -LogicalName "pluginassembly" -Id $existingAssembly.Id -Attributes @{
                version        = $assemblyProperties[2]
                culture        = $assemblyProperties[4]
                publickeytoken = $assemblyProperties[6]
                content        = $assemblyContent
            };
            $XrmClient | Update-XrmRecord -Record $assemblyRecord;
        }
        if ($PSBoundParameters.SolutionUniqueName) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -ComponentId $assemblyRecord.Id -ComponentType 91 -SolutionUniqueName $SolutionUniqueName;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Upsert-XrmAssembly -Alias *;