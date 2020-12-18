<#
    .SYNOPSIS
    Initialize new object that represent a Dataverse Connection.
#>
function New-XrmConnection {
    [CmdletBinding()]
    [OutputType([PsObject])]
    param
    (
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $hash = @{ };
        $hash["Name"] = [String]::Empty;
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
        $hash["FilePath"] = [String]::Empty;
        
        $object = New-Object PsObject -Property $hash;
        $object;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmConnection -Alias *;