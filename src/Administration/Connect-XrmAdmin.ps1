<#
    .SYNOPSIS
    Use Add-PowerAppsAccount cmdlet signs in the user or application account and saves the sign in information to cache.
    
    .DESCRIPTION
    Use this command to embed Power Apps Admin cmdlets

    .PARAMETER UserName
    User login
    
    .PARAMETER Password
    User password
    
    .PARAMETER TenantId
    AAD tenant ID (use with Client ID / secret)

    .PARAMETER TenantId
    AAD tenant ID (use with ApplicationId / ClientSecret)

    .PARAMETER ApplicationId
    AAD Application ID

    .PARAMETER ClientSecret
    AAD Application secret

    .PARAMETER CertificateThumbprint
    AAD Application Certificate Thumbprint
#>
function Connect-XrmAdmin {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [String]
        $UserName,

        [Parameter(Mandatory = $false)]
        [String]
        $Password,

        [Parameter(Mandatory = $false)]
        [String]
        $TenantId,

        [Parameter(Mandatory = $false)]
        [String]
        $ApplicationId,

        [Parameter(Mandatory = $false)]
        [String]
        $ClientSecret,

        [Parameter(Mandatory = $false)]
        [String]
        $CertificateThumbprint
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);        
    }    
    process {    

        if($Global:XrmContext -and $Global:XrmContext.CurrentConnection){
            $xrmConnection = $Global:XrmContext.CurrentConnection;
        }
        
        if ($PSBoundParameters.ContainsKey('UserName')) {
                        
            $xrmConnection = New-XrmConnection;   
            $xrmConnection.AuthType = "Office365"; 
            $xrmConnection.UserName = $UserName;
            $xrmConnection.Password = $Password;
            $xrmConnection.Credentials = $credentials;
        }
        elseif ($PSBoundParameters.ContainsKey('ClientSecret')) {
            
            $xrmConnection = New-XrmConnection;              
            $xrmConnection.AuthType = "ClientSecret"; 
            $xrmConnection.TenantId = $TenantId;
            $xrmConnection.ApplicationId = $ApplicationId;
            $xrmConnection.ClientSecret = $ClientSecret;
        }
        elseif ($PSBoundParameters.ContainsKey('CertificateThumbprint')) {
            
            $xrmConnection = New-XrmConnection;              
            $xrmConnection.AuthType = "Certificate"; 
            $xrmConnection.TenantId = $TenantId;
            $xrmConnection.ApplicationId = $ApplicationId;
            $xrmConnection.CertificateThumbprint = $CertificateThumbprint;
        }
        else {
            if (-not $Global:XrmContext) {
                Add-PowerAppsAccount;
                $Global:XrmContext.IsAdminConnected = $true;
                return;
            }
        }

        if (-not $Global:XrmContext) {            
            $Global:XrmContext = New-XrmContext; 
            $Global:XrmContext.CurrentConnection = $xrmConnection;
        }      
        else {
            if ($xrmConnection) {
                $Global:XrmContext.CurrentConnection = $xrmConnection;
            }
        }

        $Global:XrmContext.IsAdminConnected = Connect-XrmAdminInternal;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}


function Connect-XrmAdminInternal {
    [CmdletBinding()]
    param
    (
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);        
    }    
    process {    
        # This is just a wrapper for Power Apps admin connection
        # It could be done differently
        # I don't know if endpoint or audience are usefull here
        # https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/add-powerappsaccount?view=pa-ps-latest
        
        # Force disconnect to refresh token
        $Global:currentSession = $null;
        Remove-PowerAppsAccount;

        $xrmConnection = $Global:XrmContext.CurrentConnection;

        $authType = $xrmConnection.AuthType.ToLower();
        if ($authType -eq "oauth") {
            if ($xrmConnection.Password) {
                $authType = "office365";
            }
            elseif ($xrmConnection.ClientSecret) {
                $authType = "clientsecret";
            }
        }
        
        if ($authType -eq "office365") {
            
            # Set Credential object required authentications
            $credentials = Set-XrmCredentials -Login $xrmConnection.UserName -Password $xrmConnection.Password;        
            $securePassword = ConvertTo-SecureString -String $xrmConnection.Password -AsPlainText -Force;
            Add-PowerAppsAccount -Username $xrmConnection.UserName -Password $securePassword -Endpoint prod;

            return $true;
        }
        elseif ($authType -eq "clientsecret") {
            Add-PowerAppsAccount -TenantID  $xrmConnection.TenantId -ApplicationId $xrmConnection.ApplicationId -ClientSecret $xrmConnection.ClientSecret -Endpoint prod;

            return $true;
        }
        elseif ($authType -eq "certificate") {
            Add-PowerAppsAccount -TenantID  $xrmConnection.TenantId -ApplicationId $xrmConnection.ApplicationId -CertificateThumbprint $xrmConnection.CertificateThumbprint -Endpoint prod;

            return $true;
        }
        return $false;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Connect-XrmAdmin -Alias *;