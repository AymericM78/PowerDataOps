<#
    .SYNOPSIS
    Verify whether a Dataverse publisher exists.

    .DESCRIPTION
    Return $true when a publisher exists for the specified unique name.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER PublisherUniqueName
    Publisher unique name to check.

    .OUTPUTS
    System.Boolean.

    .EXAMPLE
    Test-XrmPublisher -PublisherUniqueName "contoso";
#>
function Test-XrmPublisher {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PublisherUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $publisher = Get-XrmPublisher -XrmClient $XrmClient -PublisherUniqueName $PublisherUniqueName -Columns @("publisherid");
        [bool]($null -ne $publisher);
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmPublisher -Alias *;