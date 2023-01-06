<#
    .SYNOPSIS
    Connect to TDS endpoint.
    
    .DESCRIPTION
    Specify connection parameters to run SQL commands thru TDS Endpoint.

    .PARAMETER Command
    SQL Statement
#>
function Invoke-XrmSqlCommand {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Command,

        [Parameter(Mandatory = $false)]
        [Switch]
        $IgnoreDbNull = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);      
        if(-not $Global:XrmClient){
            throw "Not connected to Dataverse instance (New-XrmClient)";
        }
        Assert-XrmTdsEndpointEnabled -XrmClient $XrmClient;  
    }    
    process {            
        $sqlConnectionString = "server=$($XrmClient.CrmConnectOrgUriActual.Host)";

        $connection = new-object System.Data.SqlClient.SQLConnection($sqlConnectionString);
        $connection.AccessToken = $XrmClient.CurrentAccessToken;
        $cmd = new-object System.Data.SqlClient.SqlCommand($Command, $connection);

        $connection.Open();
        $reader = $cmd.ExecuteReader();

        [System.Collections.ArrayList]$results = @();
        while ($reader.Read()) {
            $hash = @{};            
            for ($i = 0; $i -lt $reader.FieldCount; $i++) {
                $value = $reader.GetValue($i);
                if ($IgnoreDbNull -and $value -eq [DBNull]::Value) {
                    continue;
                }
                $hash[$reader.GetName($i)] = $value;
            }
            $object = [pscustomobject]$hash;
            $results.Add($object) | Out-Null;
        }
        $connection.Close();

        $results;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Invoke-XrmSqlCommand -Alias *;