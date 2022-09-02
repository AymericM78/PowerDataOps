<#
    .SYNOPSIS
    Initialize new object that represent a Xrm Instance.
#>
function New-XrmInstance {
    [CmdletBinding()]
    param
    (
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $hash = @{};
        $hash["Id"] = [Guid]::Empty;
        $hash["Name"] = [String]::Empty;
        $hash["UniqueName"] = [String]::Empty;
        $hash["DisplayName"] = [String]::Empty;        
        $hash["Url"] = [String]::Empty;
        $hash["ApiUrl"] = [String]::Empty;
        $hash["Location"] = [String]::Empty;
        $hash["DataCenter"] = [String]::Empty;
        $hash["Sku"] = [String]::Empty;
        $hash["Type"] = [String]::Empty;
        $hash["Version"] = [String]::Empty;
        $hash["BaseLanguage"] = [String]::Empty;
        $hash["State"] = [String]::Empty;
        $hash["CreationTemplates"] = @();
        $hash["ConnectionString"] = [String]::Empty;
        $hash["ParentConnection"] = $null;

        $object = New-Object PsObject -Property $hash;
        $object;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmInstance -Alias *;