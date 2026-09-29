<#
    .SYNOPSIS
    Retrieve connection references.

    .DESCRIPTION
    Get connection reference rows (connectionreference), optionally filtered by logical name or connector.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalName
    Connection reference logical name (connectionreferencelogicalname). (Default: all)

    .PARAMETER ConnectorId
    Connector, as a full id ("/providers/Microsoft.PowerApps/apis/shared_commondataserviceforapps") or its last segment ("shared_commondataserviceforapps"). (Default: all)

    .PARAMETER Columns
    Columns to return. (Default: connectionreferencelogicalname, connectionreferencedisplayname, connectorid, connectionid, statecode)

    .OUTPUTS
    PSCustomObject[]. Connection reference rows (XrmObject).

    .EXAMPLE
    $references = Get-XrmConnectionReferences -XrmClient $xrmClient -ConnectorId "shared_commondataserviceforapps";
    $unbound = $references | Where-Object { -not $_.connectionid };

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmConnectionReferences.md
#>
function Get-XrmConnectionReferences {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConnectorId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("connectionreferencelogicalname", "connectionreferencedisplayname", "connectorid", "connectionid", "statecode")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $query = New-XrmQueryExpression -LogicalName "connectionreference" -Columns $Columns;
        if ($PSBoundParameters.ContainsKey('LogicalName')) {
            $query = $query | Add-XrmQueryCondition -Field "connectionreferencelogicalname" -Condition Equal -Values $LogicalName;
        }
        if ($PSBoundParameters.ContainsKey('ConnectorId')) {
            $connectorSegment = $ConnectorId.Split("/")[-1];
            $query = $query | Add-XrmQueryCondition -Field "connectorid" -Condition EndsWith -Values "/$connectorSegment";
        }
        $XrmClient | Get-XrmMultipleRecords -Query $query;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmConnectionReferences -Alias *;
