<#
    .SYNOPSIS
    Update a command bar button in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing appaction record (command bar button).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER CommandReference
    EntityReference of the appaction to update.

    .PARAMETER Name
    Updated command display name.

    .PARAMETER ButtonLabelText
    Updated button label text.

    .PARAMETER TooltipTitle
    Updated tooltip title text.

    .PARAMETER Hidden
    Updated hidden state.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the updated appaction record.

    .EXAMPLE
    Set-XrmCommand -CommandReference $cmdRef -ButtonLabelText "Approve Request";
#>
function Set-XrmCommand {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $CommandReference,

        [Parameter(Mandatory = $false)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [string]
        $ButtonLabelText,

        [Parameter(Mandatory = $false)]
        [string]
        $TooltipTitle,

        [Parameter(Mandatory = $false)]
        [bool]
        $Hidden
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "appaction" -Id $CommandReference.Id;

        if ($PSBoundParameters.ContainsKey('Name')) {
            $record.Attributes["name"] = $Name;
        }
        if ($PSBoundParameters.ContainsKey('ButtonLabelText')) {
            $record.Attributes["buttonlabeltext"] = $ButtonLabelText;
        }
        if ($PSBoundParameters.ContainsKey('TooltipTitle')) {
            $record.Attributes["tooltiptitle"] = $TooltipTitle;
        }
        if ($PSBoundParameters.ContainsKey('Hidden')) {
            $record.Attributes["hidden"] = $Hidden;
        }

        Update-XrmRecord -XrmClient $XrmClient -Record $record;
        $CommandReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmCommand -Alias *;
