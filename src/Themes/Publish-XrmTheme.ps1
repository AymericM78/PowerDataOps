<#
    .SYNOPSIS
    Publish theme.
    
    .DESCRIPTION
    Apply theme to target instance

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Theme name to publish.
#>
function Publish-XrmTheme {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
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

Register-ArgumentCompleter -CommandName Publish-XrmTheme -ParameterName "Name" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $themeNames = @();
    $themes = Get-XrmThemes -Columns "name";
    $themes | ForEach-Object { $themeNames += $_.name };
    return $themeNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}
