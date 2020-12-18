<#
    .SYNOPSIS
    Retrieve multiple records with QueryExpression.
#>
function Get-XrmMultipleRecords {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.Entity[]")]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.Query.QueryBase]
        $Query,
        
        [Parameter(Mandatory = $false)]
        [int]
        $PageSize = 1000
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $enablePaging = ($null -eq $Query.TopCount);
        if ($enablePaging) {
            $pageNumber = 1;

            $Query.PageInfo = New-Object -TypeName Microsoft.Xrm.Sdk.Query.PagingInfo;
            $Query.PageInfo.PageNumber = $pageNumber;
            $Query.PageInfo.Count = $PageSize;
            $Query.PageInfo.PagingCookie = $null;
        }

        $records = @();
        while ($true) {
            $results = Protect-XrmCommand -ScriptBlock { $XrmClient.RetrieveMultiple($Query) };
            if ($enablePaging) {
                Write-Progress -Activity "Retrieving data from CRM" -Status "Processing record page : $pageNumber" -PercentComplete -1;
            }
            if ($results.Entities.Count -gt 0) {
                if ($null -eq $records) {
                    $records = $results.Entities;
                }
                else {
                    $records += $results.Entities;
                }
            }
            if ($enablePaging -and $results.MoreRecords) {
                $pageNumber++;
                $Query.PageInfo.PageNumber = $pageNumber;
                $Query.PageInfo.PagingCookie = $results.PagingCookie;
            }
            else {
                break;
            }
        }
        if ($enablePaging) {
            Write-Progress one one -completed;
        }
        $records | ConvertTo-XrmObjects;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmMultipleRecords -Alias *;