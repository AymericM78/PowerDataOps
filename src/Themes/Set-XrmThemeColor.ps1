<#
    .SYNOPSIS
    Change theme color.
    
    .DESCRIPTION
    Set theme accent color.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER SolutionUniqueName
    Theme name to update.
#>
function Set-XrmThemeColor {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LabelAndLinkColor,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $BackgroundColor
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $theme = Get-XrmRecord -XrmClient $XrmClient -LogicalName "theme" -AttributeName "name" -Value $Name;        
        $themeUpdate = New-XrmEntity -LogicalName "theme" -Id $theme.Id -Attributes @{
            "globallinkcolor"       = $LabelAndLinkColor
            "headercolor"           = $LabelAndLinkColor
            "navbarbackgroundcolor" = $BackgroundColor
        };
        Update-XrmRecord -XrmClient $XrmClient -Record $themeUpdate;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmThemeColor -Alias *;
