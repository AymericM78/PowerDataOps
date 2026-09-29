<#
    .SYNOPSIS
    Retrieve solutions records.

    .DESCRIPTION
    Get all solutions from instance with expected columns.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, version, ismanaged, installedon, createdby, publisherid, modifiedon, modifiedby)

    .PARAMETER PublisherId
    Keep the solutions of this publisher. (Default: all)

    .PARAMETER VisibleOnly
    Keep the solutions shown in the maker portal (isvisible true): excludes the system solutions such as Active and Basic.

    .OUTPUTS
    PSCustomObject[]. Solution rows (XrmObject).

    .EXAMPLE
    $publisher = Get-XrmPublisher -XrmClient $xrmClient -PublisherUniqueName "contoso";
    $solutions = Get-XrmSolutions -XrmClient $xrmClient -PublisherId $publisher.Id -VisibleOnly -Columns "uniquename", "version";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutions.md
#>
function Get-XrmSolutions {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("solutionid", "uniquename", "friendlyname", "version", "ismanaged", "installedon", "createdby", "publisherid", "modifiedon", "modifiedby"),

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $PublisherId,

        [Parameter(Mandatory = $false)]
        [switch]
        $VisibleOnly
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $querySolutions = New-XrmQueryExpression -LogicalName "solution" -Columns $Columns;
        if ($PSBoundParameters.ContainsKey('PublisherId')) {
            $querySolutions = $querySolutions | Add-XrmQueryCondition -Field "publisherid" -Condition Equal -Values $PublisherId;
        }
        if ($VisibleOnly) {
            $querySolutions = $querySolutions | Add-XrmQueryCondition -Field "isvisible" -Condition Equal -Values $true;
        }
        $solutions = $XrmClient | Get-XrmMultipleRecords -Query $querySolutions;
        $solutions;        
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmSolutions -Alias *;