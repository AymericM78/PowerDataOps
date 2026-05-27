<#
    .SYNOPSIS
    Create or update a dashboard in Microsoft Dataverse.

    .DESCRIPTION
    Upsert a systemform record of type dashboard (type = 0) by Id. Delegates to Upsert-XrmForm.

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

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted systemform record.

    .EXAMPLE
    $ref = Upsert-XrmDashboard -Id $dashboardId -Name "Sales Dashboard" -FormXml $xml -SolutionUniqueName "MySolution";
#>
function Upsert-XrmDashboard {
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
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $params = @{
            XrmClient = $XrmClient;
            Id        = $Id;
            FormXml   = $FormXml;
            FormType  = 0;
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
