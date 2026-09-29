<#
    .SYNOPSIS
    Create or update a connection reference.

    .DESCRIPTION
    Find the connection reference by logical name; create it when missing, else update the given properties.
    With SolutionUniqueName, the connection reference is added to the solution (idempotent); its component type is read from the organization (see Get-XrmSolutionComponentType).
    The platform checks ConnectionId: the connection must exist for the connector.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalName
    Connection reference logical name, with the publisher prefix (e.g. "new_sharedcommondataserviceforapps_1a2b3").

    .PARAMETER DisplayName
    Display name. (Default: LogicalName, at creation)

    .PARAMETER ConnectorId
    Connector, as a full id ("/providers/Microsoft.PowerApps/apis/shared_office365") or its last segment ("shared_office365"). Required at creation.

    .PARAMETER ConnectionId
    Connection to bind (the connection name, as shown in the connection URL).

    .PARAMETER Description
    Description of the connection reference.

    .PARAMETER SolutionUniqueName
    Unmanaged solution to add the connection reference to.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference of the connection reference.

    .EXAMPLE
    $reference = Upsert-XrmConnectionReference -XrmClient $xrmClient -LogicalName "new_dataverse" -DisplayName "Dataverse" -ConnectorId "shared_commondataserviceforapps" -SolutionUniqueName "MySolution";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmConnectionReference.md
#>
function Upsert-XrmConnectionReference {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConnectorId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConnectionId,

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [String]
        $Description,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $attributes = @{};
        if ($PSBoundParameters.ContainsKey('DisplayName')) { $attributes["connectionreferencedisplayname"] = $DisplayName; }
        if ($PSBoundParameters.ContainsKey('ConnectorId')) {
            $attributes["connectorid"] = $(if ($ConnectorId.StartsWith("/")) { $ConnectorId } else { "/providers/Microsoft.PowerApps/apis/$ConnectorId" });
        }
        if ($PSBoundParameters.ContainsKey('ConnectionId')) { $attributes["connectionid"] = $ConnectionId; }
        if ($PSBoundParameters.ContainsKey('Description')) { $attributes["description"] = $Description; }

        $existing = $XrmClient | Get-XrmRecord -LogicalName "connectionreference" -AttributeName "connectionreferencelogicalname" -Value $LogicalName -AsEntity;
        if ($existing) {
            $referenceId = $existing.Id;
            if ($attributes.Count -gt 0) {
                $XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "connectionreference" -Id $referenceId -Attributes $attributes);
            }
        }
        else {
            if (-not $attributes.ContainsKey("connectorid")) {
                throw "Connection reference '$LogicalName' does not exist: -ConnectorId is required to create it.";
            }
            $attributes["connectionreferencelogicalname"] = $LogicalName;
            if (-not $attributes.ContainsKey("connectionreferencedisplayname")) { $attributes["connectionreferencedisplayname"] = $LogicalName; }
            $referenceId = $XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "connectionreference" -Attributes $attributes);
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName') -and $referenceId) {
            $componentType = $XrmClient | Get-XrmSolutionComponentType -LogicalName "connectionreference";
            $XrmClient | Add-XrmSolutionComponent -SolutionUniqueName $SolutionUniqueName -ComponentId $referenceId -ComponentType $componentType | Out-Null;
        }

        if ($referenceId) {
            New-XrmEntityReference -LogicalName "connectionreference" -Id $referenceId;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmConnectionReference -Alias *;
