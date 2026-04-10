<#
    .SYNOPSIS
    Create an activity party for Dataverse activity records.

    .DESCRIPTION
    Build an ActivityParty Entity object to use in email from/to/cc/bcc fields or other activity party lists.
    Supports three modes: resolved party (PartyReference only), unresolved party (AddressUsed only),
    or resolved party with address override (both).

    .PARAMETER PartyReference
    Entity reference of the party (systemuser, contact, account, queue, etc.). Optional if AddressUsed is provided.

    .PARAMETER AddressUsed
    Email address to use for this party. Optional if PartyReference is provided. Can also override the resolved address.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Entity. An activityparty entity.

    .EXAMPLE
    $from = New-XrmActivityParty -PartyReference $userRef;
    $to = New-XrmActivityParty -PartyReference $contactRef -AddressUsed "alt@contoso.com";
    $unresolved = New-XrmActivityParty -AddressUsed "external@partner.com";
#>
function New-XrmActivityParty {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Entity])]
    param
    (
        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $PartyReference,

        [Parameter(Mandatory = $false)]
        [string]
        $AddressUsed
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if (-not $PSBoundParameters.ContainsKey('PartyReference') -and -not $PSBoundParameters.ContainsKey('AddressUsed')) {
            throw "At least one of PartyReference or AddressUsed must be provided.";
        }

        $party = New-XrmEntity -LogicalName "activityparty";

        if ($PSBoundParameters.ContainsKey('PartyReference')) {
            $party.Attributes["partyid"] = $PartyReference;
        }

        if ($PSBoundParameters.ContainsKey('AddressUsed')) {
            $party.Attributes["addressused"] = $AddressUsed;
        }

        $party;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmActivityParty -Alias *;
