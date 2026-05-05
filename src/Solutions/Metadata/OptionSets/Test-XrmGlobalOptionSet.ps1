<#
    .SYNOPSIS
    Verify whether a Dataverse global option set exists.

    .DESCRIPTION
    Return $true when a global option set exists for the specified name.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Global option set name.

    .PARAMETER RetrieveAsIfPublished
    Retrieve metadata as if published. Default: true.

    .OUTPUTS
    System.Boolean.

    .EXAMPLE
    Test-XrmGlobalOptionSet -Name "new_status";
#>
function Test-XrmGlobalOptionSet {
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
        $Name,

        [Parameter(Mandatory = $false)]
        [bool]
        $RetrieveAsIfPublished = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $optionSetMetadata = Get-XrmGlobalOptionSet -XrmClient $XrmClient -Name $Name -RetrieveAsIfPublished $RetrieveAsIfPublished -IfExists;
        [bool]($null -ne $optionSetMetadata);
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmGlobalOptionSet -Alias *;