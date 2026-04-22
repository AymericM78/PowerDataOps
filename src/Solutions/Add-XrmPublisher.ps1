<#
    .SYNOPSIS
    Create a new publisher in Microsoft Dataverse.

    .DESCRIPTION
    Create a publisher record with the specified unique name, display name, prefix, and option value prefix.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER UniqueName
    Publisher unique name. Must be lowercase, no spaces.

    .PARAMETER DisplayName
    Publisher display name (friendly name).

    .PARAMETER Prefix
    Customization prefix for the publisher (e.g., "contoso"). Must be 2-8 lowercase letters.

    .PARAMETER OptionValuePrefix
    Option value prefix number for the publisher. Must be between 10000 and 99999.

    .PARAMETER Description
    Optional description for the publisher.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Created publisher reference.

    .EXAMPLE
    $publisher = Add-XrmPublisher -UniqueName "contoso" -DisplayName "Contoso Ltd" -Prefix "cts" -OptionValuePrefix 28100;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/reference/entities/publisher
#>
function Add-XrmPublisher {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UniqueName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^[a-z]{2,8}$")]
        [String]
        $Prefix,

        [Parameter(Mandatory = $true)]
        [ValidateRange(10000, 99999)]
        [int]
        $OptionValuePrefix,

        [Parameter(Mandatory = $false)]
        [String]
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $attributes = @{
            "uniquename"                = $UniqueName;
            "friendlyname"              = $DisplayName;
            "customizationprefix"       = $Prefix;
            "customizationoptionvalueprefix" = $OptionValuePrefix;
        };
        if ($PSBoundParameters.ContainsKey("Description")) {
            $attributes["description"] = $Description;
        }

        $publisher = New-XrmEntity -LogicalName "publisher" -Attributes $attributes;
        $publisherId = $XrmClient | Add-XrmRecord -Record $publisher;
        $publisherReference = New-XrmEntityReference -LogicalName "publisher" -Id $publisherId;
        $publisherReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmPublisher -Alias *;
