<#
    .SYNOPSIS
    Create a connection file with all instances connection strings.
#>
function Add-XrmConnection {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Office365", "OAuth", "AD", "Ifd", "ClientSecret")]
        [ArgumentCompleter( { Get-XrmAutTypes })]
        [string]
        $AuthType,
        
        [Parameter(Mandatory=$false)]
        [String]
        $UserName,

        [Parameter(Mandatory=$false)]
        [String]
        $Password,

        [Parameter(Mandatory=$false)]
        [String]
        $TenantId,

        [Parameter(Mandatory=$false)]
        [String]
        $ApplicationId,

        [Parameter(Mandatory=$false)]
        [String]
        $ClientSecret,

        [Parameter(Mandatory=$false)]
        [String]
        $CertificateThumbprint,
        
        [Parameter(Mandatory = $false)]
        [String]
        $AzDevOpsOrgName,

        [Parameter(Mandatory = $false)]
        [String]
        $AzDevOpsProjectName,

        [Parameter(Mandatory = $false)]
        [String]
        $AzDevOpsToken
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        # Set Credential object required authentications
        $credentials = Set-XrmCredentials -Login $Login -Password $Password;        
        
        # Load instances    
        $Global:XrmContext = New-XrmContext; 
        
        # TODO : Connect-XrmAdmin with current credentials
        # TODO : Handle non admin case !!!!

        $instances = Get-XrmInstances;

        $xrmConnection = New-XrmConnection;   
        $xrmConnection.Name = $Name;     
        $xrmConnection.AuthType = $AuthType;
        $xrmConnection.UserName = $Login;
        $xrmConnection.UserPassword = $Password;
        
        $xrmConnection.Instances = $instances;
        $xrmConnection.Instances | ForEach-Object {
            $_.ParentConnection = $xrmConnection;
        }
        $xrmConnection.FilePath = [IO.Path]::Combine($Global:PowerDataOpsModuleFolderPath, "$Name.xml");

        $xrmConnection.DevOpsSettings.OrganizationName = $AzDevOpsOrgName;
        $xrmConnection.DevOpsSettings.ProjectName = $AzDevOpsProjectName;
        $xrmConnection.DevOpsSettings.Token = $AzDevOpsToken;

        $Global:XrmContext.CurrentConnection = $xrmConnection;
        
        $xrmConnection | Export-XrmConnection;
        $xrmConnection = Get-XrmConnection -Name $Name;
        $xrmConnection;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmConnection -Alias *;