<#
    .SYNOPSIS
    Export Dataverse Connection Object From File
#>

function Unprotect-XrmPassword([string] $pass) {
    
    Write-HostAndLog "Decrypting password : $pass" -Level VERB;
    $secureString = ConvertTo-SecureString -String ($pass);
    $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString);
    $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto($pointer);
    
    Write-HostAndLog "Decrypted password : $password" -Level VERB;
    return $password;
}

function Import-XrmConnection {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FilePath,

        [Parameter(Mandatory = $false)]
        [switch]
        $DoNotDecryptPassword        
    )
    begin {   

        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $fileContent = [xml] [IO.File]::ReadAllText($FilePath);
        $xrmConnection = New-XrmConnection;
        $xrmConnection.Name = $fileContent.Connection.Name;
        $xrmConnection.FilePath = $FilePath;
        $xrmConnection.AuthType = $fileContent.Connection.AuthType;
        $xrmConnection.UserName = $fileContent.Connection.UserName;
        if ($DoNotDecryptPassword) {
            $clearPassword = "*******";
        }  
        else {            
            $clearPassword = Unprotect-XrmPassword -pass $fileContent.Connection.UserPassword;
        }          
        $xrmConnection.UserPassword = $clearPassword;      
        $xrmConnection.ConnectionStringParameters = $fileContent.Connection.ConnectionStringParameters;        
            
        $xrmConnection.DevOpsSettings.OrganizationName = $fileContent.Connection.DevOps.OrganizationName;
        $xrmConnection.DevOpsSettings.ProjectName = $fileContent.Connection.DevOps.ProjectName;
        $xrmConnection.DevOpsSettings.Token = $fileContent.Connection.DevOps.Token;

        $xrmConnection.Region = $fileContent.Connection.Region;
        $xrmConnection.Instances = @();
        $fileContent.Connection.Instances.Instance | ForEach-Object {
            $instance = New-XrmInstance;
            $instance.Id = $_.Id;
            $instance.Name = $_.Name;
            $instance.UniqueName = $_.UniqueName;
            $instance.DisplayName = $_.DisplayName;
            $instance.Url = $_.Url;
            $instance.AdminApiUrl = $_.AdminApiUrl;
            $instance.ApiUrl = $_.ApiUrl;
            $instance.TenantId = $_.TenantId;
            $instance.EnviromentId = $_.EnviromentId;
            $instance.ConnectionString = $_.ConnectionString.Replace($fileContent.Connection.UserPassword, $clearPassword);           
            $instance.ParentConnection = $xrmConnection;
            $xrmConnection.Instances += $instance;
        }

        $xrmConnection;
    }
    end {       
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Import-XrmConnection -Alias *;