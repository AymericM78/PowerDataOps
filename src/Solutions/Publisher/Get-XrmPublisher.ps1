<#
    .SYNOPSIS
    Retrieve publisher record from Microsoft Dataverse.

    .DESCRIPTION
    Get a publisher by its unique name, or by its customization prefix, with expected columns.
    With Prefix, every publisher using that prefix is returned (the platform does not require prefixes to be unique).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER PublisherUniqueName
    Publisher unique name to retrieve.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, customizationprefix, customizationoptionvalueprefix, description)

    .PARAMETER Prefix
    Customization prefix (e.g. "contoso" for columns named contoso_*), instead of PublisherUniqueName.

    .OUTPUTS
    PSCustomObject. Publisher record (XrmObject).

    .EXAMPLE
    $publisher = Get-XrmPublisher -PublisherUniqueName "contoso";

    .EXAMPLE
    $publisher = Get-XrmPublisher -PublisherUniqueName "contoso" -Columns "publisherid", "friendlyname";

    .EXAMPLE
    $publisher = Get-XrmPublisher -XrmClient $xrmClient -Prefix "cts";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPublisher.md
#>
function Get-XrmPublisher {
    [CmdletBinding(DefaultParameterSetName = "UniqueName")]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline, Position = 0)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ParameterSetName = "UniqueName", Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PublisherUniqueName,

        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("publisherid", "uniquename", "friendlyname", "customizationprefix", "customizationoptionvalueprefix", "description"),

        [Parameter(Mandatory = $true, ParameterSetName = "Prefix")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Prefix
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq "Prefix") {
            $query = New-XrmQueryExpression -LogicalName "publisher" -Columns $Columns;
            $query = $query | Add-XrmQueryCondition -Field "customizationprefix" -Condition Equal -Values $Prefix;
            $XrmClient | Get-XrmMultipleRecords -Query $query;
            return;
        }
        $publisher = $XrmClient | Get-XrmRecord -LogicalName "publisher" -AttributeName "uniquename" -Value $PublisherUniqueName -Columns $Columns;
        $publisher;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmPublisher -Alias *;
