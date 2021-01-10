<#
    .SYNOPSIS
    Synchronize a webresource folder to Dataverse
#>

function Synch-XrmWebResources {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [string]
        $FolderPath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Full", "Delta")]
        [ValidateNotNullOrEmpty()]
        [string]
        $SynchronizationMode,

        [Parameter(Mandatory = $false)]
        [int]
        $SynchronizationDeltaHours = 4,

        [Parameter(Mandatory = $false)]
        [string[]]
        $SupportedExtensions = @("*.htm","*.html","*.css","*.js","*.xml","*.png","*.jpg","*.jpeg","*.gif","*.xap","*.xsl","*.ico","*.svg","*.resx")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        
        # Resolve publisher prefix for given solution
        $solution = $XrmClient | Get-XrmRecord -LogicalName "solution" -AttributeName "uniquename" -Value $SolutionUniqueName -Columns "publisherid";
        $publisher = $XrmClient | Get-XrmRecord -LogicalName "publisher" -Id $solution.publisherid_Value.Id -Columns "customizationprefix";
        $prefix = "$($publisher.customizationprefix)_";
                
        $publishXmlRequest = "<importexportxml><webresources>";
        $needToPublish = $false;
        
        # Load last modified webresources and process files
        $fullSync = ($SynchronizationMode -eq "Full");
        if($fullSync)        
        {
            $delta = [DateTime]::MinValue;
        }
        else
        {
            $now = [DateTime]::Now;
            $delta = $now.AddHours($SynchronizationDeltaHours*-1);
        }
        $webResourceFilePaths = Get-ChildItem $FolderPath -recurse -include $SupportedExtensions | where-object {$_.mode -notmatch "d"} | where-object {($_.lastwritetime -gt $delta)}; 

        ForEach-ObjectWithProgress -Collection $webResourceFilePaths -OperationName "Synchronize Webresources" -ScriptBlock {
            param($webResourceFilePath)

            if($webResourceFilePath.PSIsContainer) { continue; }

            $webResourcePath = $webResourceFilePath.FullName;
            $webResourceName = $webResourceFilePath.Name;

            Write-HostAndLog "  > Processing webresource " -NoNewline -NoTimeStamp -ForegroundColor Gray;
            Write-HostAndLog $webResourceName -NoNewline -NoTimeStamp -ForegroundColor Yellow;
            Write-HostAndLog " ..." -NoNewline -NoTimeStamp -ForegroundColor Gray;
            
            $webresourceId = Upsert-XrmWebResource -XrmClient $XrmClient -FilePath $webResourcePath -SolutionUniqueName $SolutionUniqueName -Prefix $prefix;
            if($webresourceId) {
                Write-HostAndLog "[OK]" -NoTimeStamp -ForegroundColor Green;
                $needToPublish = $true;
                $publishXmlRequest += "<webresource>$webresourceId</webresource>";
            }
            else {
                Write-HostAndLog "[Skipped]" -NoTimeStamp -ForegroundColor DarkGray;
            }            
        }
        $publishXmlRequest += "</webresources></importexportxml>";
        if($needToPublish){
            Publish-XrmCustomizations -XrmClient $XrmClient -ParameterXml $publishXmlRequest;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Synch-XrmWebResources -Alias *;