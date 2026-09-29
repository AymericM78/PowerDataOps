<#
    .SYNOPSIS
    Bind a connection reference to a connection.

    .DESCRIPTION
    Set the connection of an existing connection reference, found by logical name (e.g. after a solution import, before turning the flows on).
    Nothing is written when the connection reference is already bound to this connection. The platform checks that the connection exists for the connector.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalName
    Connection reference logical name.

    .PARAMETER ConnectionId
    Connection to bind (the connection name, as shown in the connection URL).

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference of the connection reference.

    .EXAMPLE
    Set-XrmConnectionReference -XrmClient $xrmClient -LogicalName "new_dataverse" -ConnectionId "4b3b8b5c1a2d4e6f8a9b0c1d2e3f4a5b";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmConnectionReference.md
#>
function Set-XrmConnectionReference {
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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConnectionId
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $existing = $XrmClient | Get-XrmRecord -LogicalName "connectionreference" -AttributeName "connectionreferencelogicalname" -Value $LogicalName -Columns "connectionid" -AsEntity;
        if (-not $existing) {
            throw "Connection reference '$LogicalName' not found.";
        }
        if ($existing["connectionid"] -ne $ConnectionId) {
            $XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "connectionreference" -Id $existing.Id -Attributes @{ connectionid = $ConnectionId });
        }
        New-XrmEntityReference -LogicalName "connectionreference" -Id $existing.Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmConnectionReference -Alias *;
