<#
    .SYNOPSIS
    Retrieve theme records.
    
    .DESCRIPTION
    Get themes with expected columns.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : All columns)
#>
function Get-XrmThemes {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

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
        $query = New-XrmQueryExpression -LogicalName theme -Columns "defaultentitycolor", "maincolor", "pageheaderbackgroundcolor", "themeid", "isdefaulttheme", "accentcolor", "backgroundcolor", "navbarshelfcolor", "type", "hoverlinkeffect",  "headercolor", "name", "processcontrolcolor", "globallinkcolor", "selectedlinkeffect", "controlshade", "controlborder", "logotooltip", "statuscode", "defaultcustomentitycolor", "statecode", "panelheaderbackgroundcolor", "navbarbackgroundcolor"
        $themes = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $query;
        $themes;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmThemes -Alias *;
