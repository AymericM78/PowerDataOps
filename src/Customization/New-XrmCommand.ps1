<#
    .SYNOPSIS
    Create a new command bar button in Microsoft Dataverse.

    .DESCRIPTION
    Create a new appaction record (command bar button).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Command display name.

    .PARAMETER UniqueName
    Unique name for the command.

    .PARAMETER Type
    Action type (0=Standard, 1=Dropdown, 2=SplitButton, 3=Group).

    .PARAMETER Context
    Context (0=All, 1=Entity, 2=Global).

    .PARAMETER ContextEntity
    Entity logical name when context is Entity.

    .PARAMETER ContextValue
    Context value string.

    .PARAMETER ButtonLabelText
    Button label text.

    .PARAMETER TooltipTitle
    Tooltip title text.

    .PARAMETER Hidden
    Whether the command is hidden. Default: false.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created appaction record.

    .EXAMPLE
    $ref = New-XrmCommand -Name "Approve" -UniqueName "new_approve" -Type 0 -Context 1 -ContextEntity "account" -ButtonLabelText "Approve";
#>
function New-XrmCommand {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $UniqueName,

        [Parameter(Mandatory = $true)]
        [int]
        $Type,

        [Parameter(Mandatory = $true)]
        [int]
        $Context,

        [Parameter(Mandatory = $false)]
        [string]
        $ContextEntity,

        [Parameter(Mandatory = $false)]
        [string]
        $ContextValue,

        [Parameter(Mandatory = $false)]
        [string]
        $ButtonLabelText,

        [Parameter(Mandatory = $false)]
        [string]
        $TooltipTitle,

        [Parameter(Mandatory = $false)]
        [bool]
        $Hidden = $false
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "appaction" -Attributes @{
            "name"       = $Name;
            "uniquename" = $UniqueName;
            "type"       = $Type;
            "context"    = $Context;
            "hidden"     = $Hidden;
        };

        if ($PSBoundParameters.ContainsKey('ContextEntity')) {
            $record.Attributes["contextentity"] = $ContextEntity;
        }
        if ($PSBoundParameters.ContainsKey('ContextValue')) {
            $record.Attributes["contextvalue"] = $ContextValue;
        }
        if ($PSBoundParameters.ContainsKey('ButtonLabelText')) {
            $record.Attributes["buttonlabeltext"] = $ButtonLabelText;
        }
        if ($PSBoundParameters.ContainsKey('TooltipTitle')) {
            $record.Attributes["tooltiptitle"] = $TooltipTitle;
        }

        $id = Add-XrmRecord -XrmClient $XrmClient -Record $record;
        New-XrmEntityReference -LogicalName "appaction" -Id $id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmCommand -Alias *;
