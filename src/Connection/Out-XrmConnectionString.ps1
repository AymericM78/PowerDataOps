<#
    .SYNOPSIS
Build Connection String from connection.
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
        $connectionString += "Url=$($XrmInstance.Url);";

        if($xrmConnection.AuthType -eq "Office365" -or $xrmConnection.AuthType -eq "AD"-or $xrmConnection.AuthType -eq "Ifd")
        {
            $connectionString += "Username=$($xrmConnection.Username);";
            $connectionString += "Password=$($xrmConnection.Password);";
        }
        elseif($xrmConnection.AuthType -eq "ClientSecret")
        {
            $connectionString += "ClientId=$($xrmConnection.ApplicationId);";
            $connectionString += "ClientSecret=$($xrmConnection.ClientSecret);";
        }
        elseif($xrmConnection.AuthType -eq "Certificate")
        {
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