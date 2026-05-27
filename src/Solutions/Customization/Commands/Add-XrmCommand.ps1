<#
    .SYNOPSIS
    Create a new command bar button in Microsoft Dataverse.

    .DESCRIPTION
    Create a new appaction record (command bar button).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Command display name.

    .PARAMETER Labels
    Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). Note: this sets the command's 'name' attribute; the button text shown to users is -ButtonLabelText. Example: @{ 1033 = "Approve"; 1036 = "Approuver" }

    .PARAMETER LanguageCode
    Language code used to pick the stored 'name' from -Labels. Default: 1033.

    .PARAMETER UniqueName
    Unique name for the command.

    .PARAMETER Type
    Action type (0=Standard, 1=Dropdown, 2=SplitButton, 3=Group).

    .PARAMETER Context
    Context (0=All, 1=Entity).

    .PARAMETER Location
    Location of the Command bar associated with the Modern Command. (0=Form, 1=Main Grid, 2=Sub Grid, 3=Associated Grid, 4=Quick Form, 5=Global Header, 6=Dashboard).

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

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the created command is automatically added to this solution.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created appaction record.

    .EXAMPLE
    $ref = Add-XrmCommand -Name "Approve" -UniqueName "new_approve" -Type 0 -Context 1 -ContextEntity "account" -ButtonLabelText "Approve";
    $ref = Add-XrmCommand -Name "Approve" -UniqueName "new_approve" -Type 0 -Context 1 -Location 0 -ButtonLabelText "Approve" -SolutionUniqueName "MySolution";

    .EXAMPLE
    $ref = Add-XrmCommand -Labels @{ 1033 = "Approve"; 1036 = "Approuver" } -LanguageCode 1036 -UniqueName "new_approve" -Type 0 -Context 1 -Location 0 -ButtonLabelText "Approuver";
#>
function Add-XrmCommand {
    [CmdletBinding(DefaultParameterSetName = "ByName")]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ParameterSetName = "ByName")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = "ByLabels")]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Labels,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033,

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
        
        [Parameter(Mandatory = $true)]
        [int]
        $Location,

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
        $Hidden = $false,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            $Name = Get-XrmLabelText -Labels $Labels -LanguageCode $LanguageCode;
        }

        $record = New-XrmEntity -LogicalName "appaction" -Attributes @{
            "name"       = $Name;
            "uniquename" = $UniqueName;
            "type"       = (New-XrmOptionSetValue -Value $Type);
            "context"    = (New-XrmOptionSetValue -Value $Context);
            "hidden"     = $Hidden;
            "location"       = (New-XrmOptionSetValue -Value $Location);
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

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $id -ComponentType 300 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        New-XrmEntityReference -LogicalName "appaction" -Id $id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmCommand -Alias *;
