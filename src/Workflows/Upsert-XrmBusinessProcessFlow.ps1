<#
    .SYNOPSIS
    Create or update a Business Process Flow (BPF) definition in Microsoft Dataverse.

    .DESCRIPTION
    Upsert a workflow record (category=4, BPF) by its workflow Id. When the record already exists in Dataverse,
    the cmdlet updates xaml/name/processorder/... via Update-XrmRecord. Otherwise it creates a new workflow
    using the provided Id (Add-XrmRecord).

    Localized names are persisted via the SetLocLabels message (workflow.name) when bilingual labels are
    supplied via -Labels.

    When -SolutionUniqueName is provided, the workflow is registered as a component of the target unmanaged
    solution (component type 29 - Workflow).

    When -Activate is set (default $true), the workflow is activated at the end of the operation via
    Enable-XrmWorkflow. Activation is what causes Dataverse to materialise the BPF instance entity
    (e.g. aaa_bpf_opportunitytocontractprocess) - this entity must NOT be created manually; Dataverse
    generates it automatically on first activation of the BPF.

    TODO: -Roles array is accepted for forward compatibility but role-to-process assignment
    (processroleassignment XML / Privilege records) is not handled in this iteration.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Id
    Workflow Id (used as the upsert key - the BPF GUID consumed by the generated XAML class name).

    .PARAMETER UniqueName
    Workflow unique name (publisher-prefixed, e.g. aaa_opportunitytocontractprocess).

    .PARAMETER PrimaryEntity
    Logical name of the entity the BPF is anchored on (e.g. aaa_opportunity).

    .PARAMETER Name
    Workflow display name. Used when -Labels is not provided.

    .PARAMETER Labels
    Hashtable of language code to display name. Persisted as real translations via SetLocLabels.
    Example: @{ 1033 = "Opportunity to Contract"; 1036 = "Opportunite vers Contrat" }.

    .PARAMETER LanguageCode
    Language code used to pick the stored 'name' from -Labels. Default: 1033.

    .PARAMETER Description
    Workflow description.

    .PARAMETER Xaml
    Workflow XAML definition (BPF activity tree). MUST embed the workflow Id (without dashes) in the
    Activity x:Class attribute.

    .PARAMETER Category
    Workflow category. 4 = Business Process Flow. Default: 4.

    .PARAMETER Type
    Workflow type. 1 = Definition. Default: 1.

    .PARAMETER Mode
    Workflow mode. 0 = Background. Default: 0.

    .PARAMETER Scope
    Workflow scope. 4 = Organization. Default: 4.

    .PARAMETER BusinessProcessType
    Business process type. 0 = Business Process Flow. Default: 0.

    .PARAMETER ProcessOrder
    Order of the process in the entity's BPF picker. Default: 1.

    .PARAMETER RunAs
    Run-as user code. 1 = Owner of the workflow record. Default: 1.

    .PARAMETER IsTransacted
    Whether the BPF runs in a transaction. Default: $true.

    .PARAMETER TriggerOnCreate
    Whether the BPF auto-starts on create of the primary entity. Default: $true.

    .PARAMETER IntroducedVersion
    Solution-introduced version stamp.

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the workflow is registered as a solution component (type 29).

    .PARAMETER Roles
    Array of security role unique names (currently not assigned - see TODO above).

    .PARAMETER Activate
    Activate the workflow after upsert. Default: $true.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted workflow record.

    .EXAMPLE
    $ref = Upsert-XrmBusinessProcessFlow -Id $processId -UniqueName "aaa_opportunitytocontractprocess" `
        -PrimaryEntity "aaa_opportunity" -Labels @{ 1033 = "Opportunity to Contract"; 1036 = "Opportunite vers Contrat" } `
        -Description "Opportunity BPF" -Xaml $xaml -SolutionUniqueName "svcmgr_workflows";
#>
function Upsert-XrmBusinessProcessFlow {
    [CmdletBinding(DefaultParameterSetName = "ByName")]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $Id,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $UniqueName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PrimaryEntity,

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

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Xaml,

        [Parameter(Mandatory = $false)]
        [int]
        $Category = 4,

        [Parameter(Mandatory = $false)]
        [int]
        $Type = 1,

        [Parameter(Mandatory = $false)]
        [int]
        $Mode = 0,

        [Parameter(Mandatory = $false)]
        [int]
        $Scope = 4,

        [Parameter(Mandatory = $false)]
        [int]
        $BusinessProcessType = 0,

        [Parameter(Mandatory = $false)]
        [int]
        $ProcessOrder = 1,

        [Parameter(Mandatory = $false)]
        [int]
        $RunAs = 1,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsTransacted = $true,

        [Parameter(Mandatory = $false)]
        [bool]
        $TriggerOnCreate = $true,

        [Parameter(Mandatory = $false)]
        [string]
        $IntroducedVersion,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [string[]]
        $Roles,

        [Parameter(Mandatory = $false)]
        [bool]
        $Activate = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            $Name = Get-XrmLabelText -Labels $Labels -LanguageCode $LanguageCode;
        }

        $attributes = @{
            "name"                = $Name;
            "uniquename"          = $UniqueName;
            "primaryentity"       = $PrimaryEntity;
            "xaml"                = $Xaml;
            "category"            = (New-XrmOptionSetValue -Value $Category);
            "type"                = (New-XrmOptionSetValue -Value $Type);
            "mode"                = (New-XrmOptionSetValue -Value $Mode);
            "scope"               = (New-XrmOptionSetValue -Value $Scope);
            "businessprocesstype" = (New-XrmOptionSetValue -Value $BusinessProcessType);
            "processorder"        = $ProcessOrder;
            "runas"               = (New-XrmOptionSetValue -Value $RunAs);
            "istransacted"        = $IsTransacted;
            "triggeroncreate"     = $TriggerOnCreate;
        };

        if ($PSBoundParameters.ContainsKey('Description')) {
            $attributes["description"] = $Description;
        }
        if ($PSBoundParameters.ContainsKey('IntroducedVersion')) {
            $attributes["introducedversion"] = $IntroducedVersion;
        }

        # Existence probe by workflow id - drives create vs update path.
        # We don't use the Upsert SDK message here because activation (Set-XrmRecordState) of a
        # newly created BPF must come AFTER the row exists, and pulling the existing flag lets us
        # keep the Add/Update distinction symmetric with the rest of the Workflows folder.
        $existing = $null;
        try {
            $existing = Get-XrmRecord -XrmClient $XrmClient -LogicalName "workflow" -Value $Id -Columns "workflowid", "statecode";
        }
        catch {
            $existing = $null;
        }

        if ($null -ne $existing) {
            $record = New-XrmEntity -LogicalName "workflow" -Id $Id -Attributes $attributes;
            Update-XrmRecord -XrmClient $XrmClient -Record $record | Out-Null;
        }
        else {
            $record = New-XrmEntity -LogicalName "workflow" -Id $Id -Attributes $attributes;
            Add-XrmRecord -XrmClient $XrmClient -Record $record | Out-Null;
        }

        $workflowReference = New-XrmEntityReference -LogicalName "workflow" -Id $Id;

        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            Set-XrmLocalizedLabel -XrmClient $XrmClient -EntityMoniker $workflowReference -AttributeName "name" -Labels $Labels | Out-Null;
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            # Workflow component type per Microsoft docs is 29.
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $Id -ComponentType 29 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        if ($Activate) {
            Enable-XrmWorkflow -XrmClient $XrmClient -WorkflowReference $workflowReference;
        }

        $workflowReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmBusinessProcessFlow -Alias *;
