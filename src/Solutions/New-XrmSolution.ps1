<#
    .SYNOPSIS
    Create a new unmanaged solution in Microsoft Dataverse.

    .DESCRIPTION
    Create an unmanaged solution with the specified unique name, display name, version, and publisher.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER UniqueName
    Solution unique name. Must be lowercase, no spaces.

    .PARAMETER DisplayName
    Solution display name (friendly name).

    .PARAMETER PublisherReference
    EntityReference to the publisher record that owns this solution.

    .PARAMETER Version
    Solution version string (e.g., "1.0.0.0"). Default: "1.0.0.0".

    .PARAMETER Description
    Optional description for the solution.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Created solution reference.

    .EXAMPLE
    $publisher = Get-XrmPublisher -PublisherUniqueName "contoso";
    $publisherRef = New-XrmEntityReference -LogicalName "publisher" -Id $publisher.publisherid;
    $solution = New-XrmSolution -UniqueName "contoso_mysolution" -DisplayName "My Solution" -PublisherReference $publisherRef;

    .EXAMPLE
    $solution = New-XrmSolution -UniqueName "contoso_crm" -DisplayName "Contoso CRM" -PublisherReference $publisherRef -Version "2.0.0.0" -Description "Main CRM solution";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/reference/entities/solution
#>
function New-XrmSolution {
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
        [Microsoft.Xrm.Sdk.EntityReference]
        $PublisherReference,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Version = "1.0.0.0",

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
            "uniquename"   = $UniqueName;
            "friendlyname" = $DisplayName;
            "publisherid"  = $PublisherReference;
            "version"      = $Version;
        };
        if ($PSBoundParameters.ContainsKey("Description")) {
            $attributes["description"] = $Description;
        }

        $solution = New-XrmEntity -LogicalName "solution" -Attributes $attributes;
        $solutionId = $XrmClient | Add-XrmRecord -Record $solution;
        $solutionReference = New-XrmEntityReference -LogicalName "solution" -Id $solutionId;
        $solutionReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmSolution -Alias *;
