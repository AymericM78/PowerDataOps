<#
    .SYNOPSIS
    Publish theme.
    
    .DESCRIPTION
    Apply theme to target instance

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER SolutionUniqueName
    Theme name to publish.
#>
function Publish-XrmTheme {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $theme = Get-XrmRecord -XrmClient $XrmClient -LogicalName "theme" -AttributeName "name" -Value $Name;        

        $publishThemeRequest = New-XrmRequest -Name "PublishTheme";
        $publishThemeRequest | Add-XrmRequestParameter -Name "Target" -Value $theme.Record.ToEntityReference() | Out-Null;
        Invoke-XrmRequest -XrmClient $XrmClient -Request $publishThemeRequest | Out-Null;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Publish-XrmTheme -Alias *;
