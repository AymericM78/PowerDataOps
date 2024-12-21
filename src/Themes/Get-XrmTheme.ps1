<#
    .SYNOPSIS
    Retrieve theme record.
    
    .DESCRIPTION
    Get theme by its name with expected columns.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Theme name to retrieve.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : All columns)
#>
function Get-XrmTheme {
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

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = "*"
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $theme = Get-XrmRecord -XrmClient $XrmClient -LogicalName "theme" -AttributeName "name" -Value $Name -Columns $Columns;
        if (-not $theme) {
            throw "Theme '$Name' not found!";
        }
        $theme;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmTheme -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmTheme -ParameterName "Name" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $themeNames = @();
    $themes = Get-XrmThemes -Columns "name";
    $themes | ForEach-Object { $themeNames += $_.name };
    return $themeNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}