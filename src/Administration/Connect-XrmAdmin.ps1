<#
    .SYNOPSIS
    Use Add-PowerAppsAccount cmdlet signs in the user or application account and saves the sign in information to cache.
    
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
        # This is just a wrapper for Power Apps admin connection
        # It could be done differently
        # I don't know if endpoint or audience are usefull here
        # https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/add-powerappsaccount?view=pa-ps-latest
        
        # Force disconnect to refresh tocken
        Remove-PowerAppsAccount;
          
        $Global:XrmContext = New-XrmContext; 
        $Global:XrmContext.IsOnline = $true;
        $Global:XrmContext.IsOnPremise = $false;

        $success = $false;
        if ($PSBoundParameters.ContainsKey('UserName')) {
            
            # Set Credential object required authentications
            $credentials = Set-XrmCredentials -Login $UserName -Password $Password;        
            $securePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force;
            Add-PowerAppsAccount -Username $UserName -Password $securePassword -Endpoint prod;
            
            $xrmConnection = New-XrmConnection;   
            $xrmConnection.AuthType = "Office365"; # TODO : Ifd ?
            $xrmConnection.UserName = $UserName;
            $xrmConnection.Password = $Password;
            $xrmConnection.Credentials = $credentials;
            $Global:XrmContext.CurrentConnection = $xrmConnection;

            $success = $true;
        }
        elseif ($PSBoundParameters.ContainsKey('ClientSecret')) {
            Add-PowerAppsAccount -TenantID $TenantId -ApplicationId $ApplicationId -ClientSecret $ClientSecret -Endpoint prod;

            $xrmConnection = New-XrmConnection;              
            $xrmConnection.AuthType = "ClientSecret"; 
            $xrmConnection.TenantId = $TenantId;
            $xrmConnection.ApplicationId = $ApplicationId;
            $xrmConnection.ClientSecret = $ClientSecret;
            $Global:XrmContext.CurrentConnection = $xrmConnection;

            $success = $true;
        }
        elseif ($PSBoundParameters.ContainsKey('CertificateThumbprint')) {
            Add-PowerAppsAccount -TenantID $TenantId -ApplicationId $ApplicationId -CertificateThumbprint $CertificateThumbprint -Endpoint prod;

            $xrmConnection = New-XrmConnection;              
            $xrmConnection.AuthType = "Certificate"; 
            $xrmConnection.TenantId = $TenantId;
            $xrmConnection.ApplicationId = $ApplicationId;
            $xrmConnection.CertificateThumbprint = $CertificateThumbprint;
            $Global:XrmContext.CurrentConnection = $xrmConnection;

            $success = $true;
        }
        else {
            # Add-PowerAppsAccount;
            # TODO : Handle manual auth scenario
            $success = $false;
        }
        $Global:XrmContext.IsAdminConnected = $success;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Connect-XrmAdmin -Alias *;