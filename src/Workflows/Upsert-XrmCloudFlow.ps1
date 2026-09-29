<#
    .SYNOPSIS
    Create or update a cloud flow (solution-aware Power Automate flow).

    .DESCRIPTION
    Write a cloud flow (workflow, category 5) with a caller-controlled Id, so the Id stays the same across environments.
    An activated flow is turned off, written, then turned on again. With Activate, the flow is also turned on when it was off or new.
    With SolutionUniqueName, the flow is added to the solution (idempotent).
    Raises an error when the Id belongs to a process that is not a cloud flow, or when the flow cannot be turned on again (it then stays off).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Id
    Flow unique identifier (workflowid).

    .PARAMETER Name
    Flow name.

    .PARAMETER ClientData
    Flow definition, as stored in the clientdata column (JSON with properties.definition and properties.connectionReferences).

    .PARAMETER Description
    Flow description.

    .PARAMETER SolutionUniqueName
    Unmanaged solution to add the flow to.

    .PARAMETER Activate
    Turn the flow on after writing it, even when it was off or new.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference of the flow.

    .EXAMPLE
    $clientData = Get-Content -Path ".\flows\SyncAccounts.json" -Raw;
    $flow = Upsert-XrmCloudFlow -XrmClient $xrmClient -Id "5f0e2c1a-7a39-4a57-9d0b-2f1b8c3e4d5a" -Name "Sync accounts" -ClientData $clientData -SolutionUniqueName "MySolution" -Activate;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmCloudFlow.md
#>
function Upsert-XrmCloudFlow {
    [CmdletBinding(SupportsShouldProcess)]
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
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ClientData,

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [String]
        $Description,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [switch]
        $Activate
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $flowReference = New-XrmEntityReference -LogicalName "workflow" -Id $Id;
        $existing = $XrmClient | Get-XrmRecord -LogicalName "workflow" -Id $Id -Columns "category", "statecode" -IfExists -AsEntity;
        $wasActive = $false;
        if ($existing) {
            $category = $existing["category"].Value;
            if ($category -ne 5) {
                throw "Process '$Id' is not a cloud flow (category $category).";
            }
            $wasActive = $existing["statecode"].Value -eq 1;
        }

        $attributes = @{ name = $Name; clientdata = $ClientData };
        if ($PSBoundParameters.ContainsKey('Description')) {
            $attributes["description"] = $Description;
        }

        # A failed step stops here: the next ones would act on a flow in an unknown state
        if ($wasActive) {
            $XrmClient | Disable-XrmWorkflow -WorkflowReference $flowReference -ErrorAction Stop | Out-Null;
        }
        if ($existing) {
            $XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "workflow" -Id $Id -Attributes $attributes) -ErrorAction Stop;
        }
        else {
            $attributes["category"] = New-XrmOptionSetValue -Value 5;
            $attributes["type"] = New-XrmOptionSetValue -Value 1;
            $attributes["primaryentity"] = "none";
            $XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "workflow" -Id $Id -Attributes $attributes) -ErrorAction Stop | Out-Null;
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $XrmClient | Add-XrmSolutionComponent -SolutionUniqueName $SolutionUniqueName -ComponentId $Id -ComponentType 29 | Out-Null;
        }

        if ($wasActive -or $Activate) {
            try {
                $XrmClient | Enable-XrmWorkflow -WorkflowReference $flowReference -ErrorAction Stop | Out-Null;
            }
            catch {
                throw "Cloud flow '$Name' ($Id) was written but could not be turned on: $($_.Exception.Message)";
            }
        }

        $flowReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmCloudFlow -Alias *;
