<#
    .SYNOPSIS
    Authenticate user to discovery service
#>
function Connect-XrmUser {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [String]
        $UserName,

        [Parameter(Mandatory=$false)]
        [String]
        $Password,        

        [Parameter(Mandatory = $true)]
        # TODO : Check AD and IFD
        [ValidateSet("Office365", "AD", "Ifd")]
        [string]
        $AuthType,
        
        [Parameter(Mandatory = $false)]
        [String]
        [ArgumentCompleter( { Get-XrmRegions })]
        $Region
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);        
    }    
    process {   

        # Set Credential object required authentications
        $credentials = Set-XrmCredentials -Login $UserName -Password $Password;        
                
        # Initialize context   
        $Global:XrmContext = New-XrmContext; 

        $xrmConnection = New-XrmConnection;   
        $xrmConnection.AuthType = $AuthType;
        $xrmConnection.UserName = $UserName;
        $xrmConnection.Password = $Password;
        $xrmConnection.Credentials = $credentials;
        $xrmConnection.Region = $Region;

        $Global:XrmContext.IsOnline = ($AuthType -eq "Office365");
        $Global:XrmContext.IsOnPremise = ($AuthType -ne "Office365");

        $Global:XrmContext.CurrentConnection = $xrmConnection;
        $Global:XrmContext.IsUserConnected = $true;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Connect-XrmUser -Alias *;