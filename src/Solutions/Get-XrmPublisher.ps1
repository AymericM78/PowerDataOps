<#
    .SYNOPSIS
    Retrieve publisher record from Microsoft Dataverse.

    .DESCRIPTION
    Get a publisher by its unique name with expected columns.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER PublisherUniqueName
    Publisher unique name to retrieve.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, customizationprefix, customizationoptionvalueprefix, description)

    .OUTPUTS
    PSCustomObject. Publisher record (XrmObject).

    .EXAMPLE
    $publisher = Get-XrmPublisher -PublisherUniqueName "contoso";

    .EXAMPLE
    $publisher = Get-XrmPublisher -PublisherUniqueName "contoso" -Columns "publisherid", "friendlyname";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/reference/entities/publisher
#>
function Get-XrmPublisher {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PublisherUniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("publisherid", "uniquename", "friendlyname", "customizationprefix", "customizationoptionvalueprefix", "description")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $publisher = $XrmClient | Get-XrmRecord -LogicalName "publisher" -AttributeName "uniquename" -Value $PublisherUniqueName -Columns $Columns;
        $publisher;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmPublisher -Alias *;
