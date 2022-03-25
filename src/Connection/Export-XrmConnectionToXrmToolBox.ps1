
. "$PsScriptRoot\..\_Internals\CryptoManager.ps1"

<#
    .SYNOPSIS
    Export instances collection to XML file with connection strings to XrmToolBox connection file.

    .DESCRIPTION
    Populate XrmToolbox connections with available instance for given user.

    .PARAMETER Name
    XTB connection name.
    
    .PARAMETER OverrideConnectionStringFormat
    Provide the ConnectionString template in order to access to instances with different credentials.

    .PARAMETER XtbConnectionPath
    XTB connections folder path. (Default: $env:APPDATA\MscrmTools\XrmToolBox\Connections)

    .EXAMPLE
    Connect-XrmUser -AuthType Office365 -UserName "user@contoso.fake" -Password "MyPass123"
    Export-XrmConnectionToXrmToolBox -Name "Contoso"

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/samples/XrmToolBox%20Connection%20Provisionning.md
#>
function Export-XrmConnectionToXrmToolBox {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline = $True)]
        [Object]
        $XrmConnection = $Global:XrmContext.CurrentConnection,
        
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $false)]
        [String]
        $OverrideConnectionStringFormat = "",

        [Parameter(Mandatory = $false)]
        [String]
        $XtbConnectionPath = "$env:APPDATA\MscrmTools\XrmToolBox\Connections"
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        $filePath = "$XtbConnectionPath\$($Name).xml";
        $instances = Get-XrmInstances;
        
        $fileContent = New-Object "System.Text.Stringbuilder";
        $fileContent.AppendLine('<?xml version="1.0" encoding="utf-8"?>') | Out-Null;
        $fileContent.AppendLine('<CrmConnections>') | Out-Null;
        $fileContent.AppendLine('   <ByPassProxyOnLocal>false</ByPassProxyOnLocal>') | Out-Null;
        $fileContent.AppendLine('   <Connections>') | Out-Null;

        foreach ($instance in $instances) {
            if(-not $instance.Url) {
                continue;
            }
            $instance.Url = $instance.Url.TrimEnd('/');

            $serverName = $instance.Url.Replace("https://", "");
            $orgDataSvcUrl = "$($instance.Url)/XRMServices/2011/OrganizationData.svc";
            $orgSvcUrl = "$($instance.Url)/XRMServices/2011/Organization.svc";

            $connectionString = $instance | Out-XrmConnectionString;
            if($Global:XrmContext.CurrentConnection.AuthType -eq "Office365"){
                $encryptedPassword = Protect-XrmToolBoxPassword -Password $XrmConnection.Password;
                $connectionString = $connectionString.Replace($XrmConnection.Password, $encryptedPassword);
            }
            elseif($Global:XrmContext.CurrentConnection.AuthType -eq "OAuth"){
                if($XrmConnection.Password){
                    $encryptedPassword = Protect-XrmToolBoxPassword -Password $XrmConnection.Password;
                    $connectionString = $connectionString.Replace($XrmConnection.Password, $encryptedPassword);
                }
            }
            elseif ($Global:XrmContext.CurrentConnection.AuthType -eq "ClientSecret"){
                $encryptedClientSecret = Protect-XrmToolBoxPassword -Password $XrmConnection.ClientSecret;
                $connectionString = $connectionString.Replace($XrmConnection.ClientSecret, $encryptedClientSecret);
            }            
            
            $fileContent.AppendLine('     <ConnectionDetail>') | Out-Null;        
            $fileContent.AppendLine('       <ConnectionString>' + $connectionString + '</ConnectionString>') | Out-Null;
            $fileContent.AppendLine('       <UseConnectionString>true</UseConnectionString>') | Out-Null;
            $fileContent.AppendLine('       <WebApplicationUrl>' + $($instance.Url) + '</WebApplicationUrl>') | Out-Null;
            $fileContent.AppendLine('       <AuthType>OnlineFederation</AuthType>') | Out-Null;
            $fileContent.AppendLine('       <ConnectionId>' + (New-Guid) + '</ConnectionId>') | Out-Null;
            $fileContent.AppendLine('       <ConnectionName>' + $($Name) + ' - ' + $instance.DisplayName + '</ConnectionName>') | Out-Null;
            $fileContent.AppendLine('       <ServerName>' + $($serverName) + '</ServerName>') | Out-Null;
            $fileContent.AppendLine('       <ServerPort>443</ServerPort>') | Out-Null;
            $fileContent.AppendLine('       <OriginalUrl>' + $($instance.Url) + '</OriginalUrl>') | Out-Null
            $fileContent.AppendLine('       <Organization>' + $($instance.UniqueName) + '</Organization>') | Out-Null;
            $fileContent.AppendLine('       <OrganizationUrlName>' + $($organization.Name) + '</OrganizationUrlName>') | Out-Null;
            $fileContent.AppendLine('       <OrganizationServiceUrl>' + $($orgSvcUrl) + '</OrganizationServiceUrl>') | Out-Null;
            $fileContent.AppendLine('       <OrganizationDataServiceUrl>' + $($orgDataSvcUrl) + '</OrganizationDataServiceUrl>') | Out-Null;
            $fileContent.AppendLine('       <EnvironmentHighlightingInfo>') | Out-Null;
            $fileContent.AppendLine('          <Color>' + [string]::Format("#{0:X6}", [Random]::new().Next(0x1000000)) + '</Color>') | Out-Null;
            $fileContent.AppendLine('          <Text>' + $($instance.DisplayName) + '</Text>') | Out-Null;
            $fileContent.AppendLine('          <TextColor>#000000</TextColor>') | Out-Null;
            $fileContent.AppendLine('       </EnvironmentHighlightingInfo>') | Out-Null;       
            $fileContent.AppendLine('     </ConnectionDetail>') | Out-Null;
        }

        $fileContent.AppendLine('   </Connections>') | Out-Null;
        $fileContent.AppendLine('   <IsReadOnly>false</IsReadOnly>') | Out-Null;
        $fileContent.AppendLine('   <Name>' + $($Name) + '</Name>') | Out-Null;
        $fileContent.AppendLine('   <UseCustomProxy>false</UseCustomProxy>') | Out-Null;
        $fileContent.AppendLine('   <UseDefaultCredentials>false</UseDefaultCredentials>') | Out-Null;
        $fileContent.AppendLine('   <UseInternetExplorerProxy>false</UseInternetExplorerProxy>') | Out-Null;
        $fileContent.AppendLine('   <UseMruDisplay>false</UseMruDisplay>') | Out-Null;
        $fileContent.AppendLine('</CrmConnections>') | Out-Null;

        $fileContent.ToString() | Out-File -FilePath $filePath -Encoding utf8 -Force;
        
        # Add new connection file to XrmToolBox
        $xtbConnectionFilePath = "$XtbConnectionPath\MscrmTools.ConnectionsList.xml"

        $xtbContent = [xml] [IO.File]::ReadAllText($xtbConnectionFilePath);

        $exist = $xtbContent.ConnectionsList.Files.ConnectionFile | Where-Object Name -eq $Name;
        if ($exist) {
            return;
        }
        $lastUsedItem = $xtbContent.CreateElement("LastUsed");
        $lastUsedItem.InnerText = (get-date -Format "o");

        $nameItem = $xtbContent.CreateElement("Name");
        $nameItem.InnerText = $Name;

        $pathItem = $xtbContent.CreateElement("Path");
        $pathItem.InnerText = $filePath;
        
        $connectionFileNode = $xtbContent.CreateElement("ConnectionFile");
        $connectionFileNode.AppendChild($lastUsedItem) | Out-Null;
        $connectionFileNode.AppendChild($nameItem) | Out-Null;
        $connectionFileNode.AppendChild($pathItem) | Out-Null;

        $xtbContent.ConnectionsList.Files.AppendChild($connectionFileNode) | Out-Null;
        $xtbContent.Save($xtbConnectionFilePath);        
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Export-XrmConnectionToXrmToolBox -Alias *;