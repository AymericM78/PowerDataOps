<#
    .SYNOPSIS
    Import XrmToolBox connection from file.

    .DESCRIPTION
    Populate XrmToolbox connection object from XML file.

    .PARAMETER Name
    XTB connections file path.
#>
function Import-XrmConnection {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        [ValidateScript( { Test-Path $_ })]
        $FilePath
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $connectionXml = [xml] [IO.File]::ReadAllText($FilePath);

        $connection = New-XrmConnection;
        $connection.Name = $connectionXml.CrmConnections.Name;
        $connection.FilePath = $FilePath;
        $connection.Instances = @();
        foreach ($connectionDetail in $connectionXml.CrmConnections.Connections.ConnectionDetail) {
            $instance = New-XrmInstance;
            $instance.ParentConnection = $connection;
            $instance.Url = $connectionDetail.WebApplicationUrl;
            $instance.Name = $connectionDetail.ConnectionName;
            $instance.UniqueName = $connectionDetail.OrganizationUrlName;
            $instance.ConnectionString = $connectionDetail.ConnectionString;
            $connection.Instances += $instance;
        }
        $connection;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Import-XrmConnection -Alias *;