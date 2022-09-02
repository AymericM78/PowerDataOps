<#
    .SYNOPSIS
    Initialize new object that represent a Dataverse Connection.
#>
function New-XrmConnection {
    [CmdletBinding()]
    param
    ( 
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConnectionString
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $hash = @{ };
        $hash["Name"] = [String]::Empty;
        $hash["Url"] = [String]::Empty;
        $hash["AuthType"] = [String]::Empty;
        $hash["Credentials"] = [System.Management.Automation.PSCredential]::Empty;
        $hash["UserName"] = [String]::Empty;
        $hash["Password"] = [String]::Empty;
        $hash["TenantId"] = [String]::Empty;
        $hash["Region"] = [String]::Empty;
        $hash["ApplicationId"] = [String]::Empty;
        $hash["ClientSecret"] = [String]::Empty;
        $hash["CertificateThumbprint"] = [String]::Empty;		
		
        $hash["Instances"] = $null;
        $hash["DevOpsSettings"] = New-XrmDevOpsSettings;
        
        $object = New-Object PsObject -Property $hash;
        
        if ($PSBoundParameters.ContainsKey('ConnectionString')) {
            $object.Url = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "Url";
            $object.AuthType = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "AuthType";
            $object.UserName = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "UserName";
            $object.Password = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "Password";
            $object.ApplicationId = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "ClientId";
            $object.ClientSecret = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "ClientSecret";
            $object.CertificateThumbprint = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName "Thumbprint";
        }

        $object;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmConnection -Alias *;