. "$PsScriptRoot\..\_Internals\CryptoManager.ps1"
<#
    .SYNOPSIS
    Build Connection String from instance object.

    .DESCRIPTION
    Output connection string from given Microsoft Dataverse instance object.

    .PARAMETER XrmInstance
    Microsoft Dataverse instance object.
#>
function Out-XrmConnectionString {
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        $XrmInstance
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $xrmConnection = $Global:XrmContext.CurrentConnection;

        # TODO : Handle different auth type connection string formats
        #   => https://docs.microsoft.com/fr-fr/powerapps/developer/common-data-service/xrm-tooling/use-connection-strings-xrm-tooling-connect
        $connectionString = "AuthType=$($xrmConnection.AuthType);";

        if($xrmConnection.AuthType -eq "Office365"){                
            # Override O365
            $ConnectionString = "AuthType=OAuth;AppId=51f81489-12ee-4a9e-aaae-a2591f45987d; RedirectUri=app://58145B91-0C36-4500-8554-080854F2AC97;LoginPrompt=Auto;";
        }

        $connectionString += "Url=$($XrmInstance.Url);";

        if ($xrmConnection.AuthType -eq "Office365" -or $xrmConnection.AuthType -eq "AD" -or $xrmConnection.AuthType -eq "Ifd") {
            $connectionString += "Username=$($xrmConnection.Username);";
            if(-not $Global:XrmContext.IsEncrypted){
                $connectionString += "Password=$($xrmConnection.Password);";
            }
            else{
                $connectionString += "Password=$(Protect-XrmToolBoxPassword -Password $xrmConnection.Password);";
            }
        }
        elseif ($xrmConnection.AuthType -eq "ClientSecret") {
            $connectionString += "ClientId=$($xrmConnection.ApplicationId);";
            if(-not $Global:XrmContext.IsEncrypted){
                $connectionString += "ClientSecret=$($xrmConnection.ClientSecret);";
            }
            else{
                $connectionString += "ClientSecret=$(Protect-XrmToolBoxPassword -Password $xrmConnection.ClientSecret);";
            }
        }
        elseif ($xrmConnection.AuthType -eq "Certificate") {
            $connectionString += "ClientId=$($xrmConnection.ApplicationId);";
            $connectionString += "thumbprint=$($xrmConnection.CertificateThumbprint);";
        }
        $connectionString += "SkipDiscovery=true;";
        $connectionString;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Out-XrmConnectionString -Alias *;