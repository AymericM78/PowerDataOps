<#
    .SYNOPSIS
    Retrieve savedquery records.

    .DESCRIPTION
    Get all saved query according to entity name and predefined columns.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER LogicalName
    Gets or sets the entity name in order to filter views name.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)
#>
function Get-XrmViews {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityLogicalName,      

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("*")
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $queryViews = New-XrmQueryExpression -LogicalName "savedquery" -Columns $Columns;
        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {           
            $queryViews = $queryViews | Add-XrmQueryCondition -Field "returnedtypecode" -Condition Equal -Values $EntityLogicalName;
        }
        $views = $XrmClient | Get-XrmMultipleRecords -Query $queryViews;
        $views;        
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmViews -Alias *;