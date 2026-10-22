<#
    .SYNOPSIS
    Create or update a dashboard in Microsoft Dataverse.

    .DESCRIPTION
    Upsert a systemform record of type dashboard by Id: classic (type = 0) by default, interactive experience with FormType 10. Delegates to Upsert-XrmForm.
    Dataverse keeps the type of an existing form and ignores the one sent: without FormType, an existing dashboard keeps its type.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Id
    Dashboard (systemform) Id used as the upsert key.

    .PARAMETER Name
    Dashboard display name.

    .PARAMETER Labels
    Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code), and every provided language is persisted as a real translation via SetLocLabels (delegated to Upsert-XrmForm). Example: @{ 1033 = "Sales Dashboard"; 1036 = "Tableau de bord des ventes" }

    .PARAMETER LanguageCode
    Language code used to pick the stored 'name' from -Labels. Default: 1033.

    .PARAMETER FormXml
    Dashboard form XML definition.

    .PARAMETER Description
    Dashboard description.

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the dashboard is added to this solution.

    .PARAMETER FormType
    Dashboard type: 0 = classic (default), 10 = interactive experience. When given, an existing dashboard of another type raises an error before anything is written: its type cannot change (delete it, then upsert it again).

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted systemform record.

    .EXAMPLE
    $ref = Upsert-XrmDashboard -Id $dashboardId -Name "Sales Dashboard" -FormXml $xml -SolutionUniqueName "MySolution";

    .EXAMPLE
    $ref = Upsert-XrmDashboard -Id $dashboardId -Name "Cash follow-up" -FormXml $interactiveXml -FormType 10;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmDashboard.md
#>
function Upsert-XrmDashboard {
    [CmdletBinding(DefaultParameterSetName = "ByName", SupportsShouldProcess)]
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
        $FormXml,

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateSet(0, 10)]
        [int]
        $FormType = 0
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        # The upsert would keep the type of an existing dashboard without a word: an explicit type is checked first
        if ($PSBoundParameters.ContainsKey('FormType')) {
            $existing = Get-XrmRecord -XrmClient $XrmClient -LogicalName "systemform" -Id $Id -Columns "type" -IfExists;
            if ($existing) {
                $existingType = $existing | Get-XrmAttributeValue -Name "type" -Raw;
                if ($existingType -ne $FormType) {
                    throw [System.InvalidOperationException]::new("Dashboard $Id exists with form type $existingType, not $($FormType): Dataverse keeps the type of an existing form. Delete it, then upsert it again to change its type.");
                }
            }
        }

        $params = @{
            XrmClient = $XrmClient;
            Id        = $Id;
            FormXml   = $FormXml;
            FormType  = $FormType;
        };

        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            $params["Labels"] = $Labels;
            $params["LanguageCode"] = $LanguageCode;
        }
        else {
            $params["Name"] = $Name;
        }

        if ($PSBoundParameters.ContainsKey('Description')) {
            $params["Description"] = $Description;
        }
        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $params["SolutionUniqueName"] = $SolutionUniqueName;
        }

        Upsert-XrmForm @params;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmDashboard -Alias *;
