<#
    .SYNOPSIS
    Create a new dashboard in Microsoft Dataverse.

    .DESCRIPTION
    Create a new systemform record of type dashboard (type = 0). Delegates to Add-XrmForm.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Dashboard display name.

    .PARAMETER FormXml
    Dashboard form XML definition.

    .PARAMETER Description
    Dashboard description.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created systemform record.

    .EXAMPLE
    $ref = Add-XrmDashboard -Name "Sales Dashboard" -FormXml $xml;
#>
function Add-XrmDashboard {
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
            XrmClient = $XrmClient;
            Name      = $Name;
            FormXml   = $FormXml;
            FormType  = 0;
        };

        if ($PSBoundParameters.ContainsKey('Description')) {
            $params["Description"] = $Description;
        }

        $ref = Add-XrmForm @params;
        $ref;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmDashboard -Alias *;