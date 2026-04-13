<#
    .SYNOPSIS
    Create a new email activity record in Microsoft Dataverse.

    .DESCRIPTION
    Create an email activity record with from, to, cc, bcc, subject and body. Uses Add-XrmRecord.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER From
    Array of activityparty entities for the sender (use New-XrmActivityParty).

    .PARAMETER To
    Array of activityparty entities for the recipients (use New-XrmActivityParty).

    .PARAMETER Cc
    Array of activityparty entities for CC recipients. Optional.

    .PARAMETER Bcc
    Array of activityparty entities for BCC recipients. Optional.

    .PARAMETER Subject
    Email subject.

    .PARAMETER Body
    Email body (HTML or plain text).

    .PARAMETER RegardingObjectReference
    Entity reference of the regarding object. Optional.

    .PARAMETER DirectionCode
    True = outgoing, False = incoming. Default: true (outgoing).

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created email record.

    .EXAMPLE
    $from = New-XrmActivityParty -PartyReference $userRef;
    $to = New-XrmActivityParty -PartyReference $contactRef;
    $ref = New-XrmEmail -From @($from) -To @($to) -Subject "Hello" -Body "<p>World</p>";
#>
function New-XrmEmail {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Entity[]]
        $From,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Entity[]]
        $To,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Entity[]]
        $Cc,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Entity[]]
        $Bcc,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Subject,

        [Parameter(Mandatory = $false)]
        [string]
        $Body,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RegardingObjectReference,

        [Parameter(Mandatory = $false)]
        [bool]
        $DirectionCode = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "email" -Attributes @{
            "from"          = [Microsoft.Xrm.Sdk.EntityCollection] (New-XrmEntityCollection -Entities $From);
            "to"            = [Microsoft.Xrm.Sdk.EntityCollection] (New-XrmEntityCollection -Entities $To);
            "subject"       = $Subject;
            "directioncode" = $DirectionCode;
        };

        if ($PSBoundParameters.ContainsKey('Body')) {
            $record.Attributes["description"] = $Body;
        }

        if ($PSBoundParameters.ContainsKey('Cc')) {
            $record.Attributes["cc"] = [Microsoft.Xrm.Sdk.EntityCollection] (New-XrmEntityCollection -Entities $Cc);
        }

        if ($PSBoundParameters.ContainsKey('Bcc')) {
            $record.Attributes["bcc"] = [Microsoft.Xrm.Sdk.EntityCollection] (New-XrmEntityCollection -Entities $Bcc);
        }

        if ($PSBoundParameters.ContainsKey('RegardingObjectReference')) {
            $record.Attributes["regardingobjectid"] = $RegardingObjectReference;
        }

        $id = Add-XrmRecord -XrmClient $XrmClient -Record $record;
        New-XrmEntityReference -LogicalName "email" -Id $id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmEmail -Alias *;
