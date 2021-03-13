<#
    .SYNOPSIS
    Connect to TDS endpoint.
    
    .DESCRIPTION
    Specify connection parameters to run SQL commands thru TDS Endpoint.

    .PARAMETER UserName
    User login
    
    .PARAMETER Password
    User password

    .PARAMETER Url
    Microsoft Dataverse instance url
#>
function Connect-XrmTdsEndpoint {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Password,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Url
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);        
    }    
    process {            
        $Global:XrmContext = New-XrmContext; 
        $Global:XrmContext.IsOnline = $true;

        $xrmConnection = New-XrmConnection;   
        $xrmConnection.UserName = $UserName;
        $xrmConnection.Password = $Password;

        $Global:XrmContext.CurrentConnection = $xrmConnection;

        $xrmInstance = New-XrmInstance;
        $xrmInstance.Url = $Url;

        $Global:XrmContext.CurrentInstance = $xrmInstance;           
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Connect-XrmTdsEndpoint -Alias *;