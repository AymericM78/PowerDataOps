<#
    .SYNOPSIS
    Export instances collection to XML file with connection strings to XrmToolBox connection file.
#>

function Protect-XrmToolBoxPassword
{
    PARAM(
        [Parameter(Mandatory = $True)]
        [string]
        $Password
    )

    $CryptoHashAlgorythm = "SHA1";
    $CryptoInitVector = "ahC3@bCa2Didfc3d";
    $CryptoKeySize = 256;
    $CryptoPassPhrase = "MsCrmTools";
    $CryptoPasswordIterations = 2;
    $CryptoSaltValue = "Tanguy 92*";

    $initVectorBytes = [System.Text.Encoding]::ASCII.GetBytes($CryptoInitVector);
    $saltValueBytes = [System.Text.Encoding]::ASCII.GetBytes($CryptoSaltValue);
    $plainTextBytes = [System.Text.Encoding]::UTF8.GetBytes($Password);

    $passwordBytes = new-object "System.Security.Cryptography.PasswordDeriveBytes" -ArgumentList $CryptoPassPhrase, $saltValueBytes, $CryptoHashAlgorythm, $CryptoPasswordIterations;
    $keyBytes = $passwordBytes.GetBytes($CryptoKeySize / 8);

    $symmetricKey = new-object "System.Security.Cryptography.RijndaelManaged";
    $symmetricKey.Mode = [System.Security.Cryptography.CipherMode]::CBC;
    $encryptor = $symmetricKey.CreateEncryptor($keyBytes, $initVectorBytes);

    $memoryStream = new-object "System.IO.MemoryStream";
    $cryptoStreamMode = [System.Security.Cryptography.CryptoStreamMode]::Write;;
    $cryptoStream = new-object "System.Security.Cryptography.CryptoStream" -ArgumentList $memoryStream, $encryptor, $cryptoStreamMode;
    $cryptoStream.Write($plainTextBytes, 0, $plainTextBytes.Length);
    $cryptoStream.FlushFinalBlock() | Out-Null;

    $cipherTextBytes = $memoryStream.ToArray();

    $memoryStream.Close() | Out-Null;
    $cryptoStream.Close() | Out-Null;

    $cipherText = [Convert]::ToBase64String($cipherTextBytes);

    return $cipherText;
}

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
        $XtbConnectionPath = "$env:APPDATA\MscrmTools\XrmToolBox\Connections"
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        $encryptedPassword = Protect-XrmToolBoxPassword -Password $XrmConnection.Password;
        $filePath = "$XtbConnectionPath\$($Name).xml";
        $instances = Get-XrmInstances;
        
        $fileContent = New-Object "System.Text.Stringbuilder";
        $fileContent.AppendLine('<?xml version="1.0" encoding="utf-8"?>') | Out-Null;
        $fileContent.AppendLine('<CrmConnections>') | Out-Null;
        $fileContent.AppendLine('   <Connections>') | Out-Null;
        $fileContent.AppendLine('     <ByPassProxyOnLocal>false</ByPassProxyOnLocal>') | Out-Null;

        foreach($instance in $instances)
        {
            $serverName = $instance.Url.Replace("https://", "");
            $orgDataSvcUrl = "$($instance.Url)/XRMServices/2011/OrganizationData.svc";
            $orgSvcUrl = "$($instance.Url)/XRMServices/2011/Organization.svc";

            $connectionString = $instance | Out-XrmConnectionString;
            $connectionString = $connectionString.Replace($XrmConnection.Password, $encryptedPassword);

            $fileContent.AppendLine('     <ConnectionDetail>') | Out-Null;        
            $fileContent.AppendLine('       <ConnectionString>' + $connectionString + '</ConnectionString>') | Out-Null;
            $fileContent.AppendLine('       <UseConnectionString>true</UseConnectionString>') | Out-Null;
            $fileContent.AppendLine('       <WebApplicationUrl>' + $($instance.Url) + '</WebApplicationUrl>') | Out-Null;
            $fileContent.AppendLine('       <AuthType>OnlineFederation</AuthType>') | Out-Null;
            $fileContent.AppendLine('       <AzureAdAppId>00000000-0000-0000-0000-000000000000</AzureAdAppId>') | Out-Null;
            $fileContent.AppendLine('       <ConnectionId>' + (New-Guid) + '</ConnectionId>') | Out-Null;
            $fileContent.AppendLine('       <ConnectionName>' + $($Name) + ' - ' + $instance.DisplayName +'</ConnectionName>') | Out-Null;
            $fileContent.AppendLine('       <ServerName>' + $($serverName) + '</ServerName>') | Out-Null;
            $fileContent.AppendLine('       <ServerPort>443</ServerPort>') | Out-Null;
            $fileContent.AppendLine('       <OriginalUrl>' + $($instance.Url) + '</OriginalUrl>') | Out-Null
            $fileContent.AppendLine('       <Organization>' + $($instance.UniqueName) + '</Organization>') | Out-Null;
            $fileContent.AppendLine('       <OrganizationUrlName>' + $($organization.Name) + '</OrganizationUrlName>') | Out-Null;
            $fileContent.AppendLine('       <OrganizationServiceUrl>' + $($orgSvcUrl) + '</OrganizationServiceUrl>') | Out-Null;
            $fileContent.AppendLine('       <OrganizationDataServiceUrl>' + $($orgDataSvcUrl) + '</OrganizationDataServiceUrl>') | Out-Null;
            $fileContent.AppendLine('       <OrganizationVersion>' + $($instance.Version) + '</OrganizationVersion>') | Out-Null;
            $fileContent.AppendLine('       <EnvironmentHighlightingInfo>') | Out-Null;
            $fileContent.AppendLine('          <Color>' + [string]::Format("#{0:X6}", [Random]::new().Next(0x1000000)) + '</Color>') | Out-Null;
            $fileContent.AppendLine('          <Text>' + $($instance.DisplayName) + '</Text>') | Out-Null;
            $fileContent.AppendLine('          <TextColor>#000000</TextColor>') | Out-Null;
            $fileContent.AppendLine('       </EnvironmentHighlightingInfo>') | Out-Null;
            $fileContent.AppendLine('       <LastUsedOn>14/01/1983 00:00:00</LastUsedOn>') | Out-Null;        
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
        if($exist)
        {
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