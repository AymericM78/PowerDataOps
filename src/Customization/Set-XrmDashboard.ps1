<#
    .SYNOPSIS
    Update a dashboard in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing systemform record (dashboard). Delegates to Set-XrmForm.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER DashboardReference
    EntityReference of the systemform (dashboard) to update.

    .PARAMETER Name
    Updated dashboard display name.

    .PARAMETER FormXml
    Updated dashboard form XML definition.

    .PARAMETER Description
    Updated description.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the updated systemform record.

    .EXAMPLE
    Set-XrmDashboard -DashboardReference $dashRef -Name "Updated Sales Dashboard";
#>
function Set-XrmDashboard {
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
        $DashboardReference,

        [Parameter(Mandatory = $false)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [string]
        $FormXml,

        [Parameter(Mandatory = $false)]
        [string]
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $params = @{
            XrmClient     = $XrmClient;
            FormReference = $DashboardReference;
        };

        if ($PSBoundParameters.ContainsKey('Name')) {
            $params["Name"] = $Name;
        }
        if ($PSBoundParameters.ContainsKey('FormXml')) {
            $params["FormXml"] = $FormXml;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $params["Description"] = $Description;
        }

        Set-XrmForm @params;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmDashboard -Alias *;
