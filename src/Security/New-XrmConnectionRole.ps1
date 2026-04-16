<#
    .SYNOPSIS
    Create a new connection role in Microsoft Dataverse.

    .DESCRIPTION
    Create a connectionrole record.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Connection role display name.

    .PARAMETER Category
    Connection role category value. Optional. (e.g. 1=Business, 2=Family, 3=Social, 4=Sales, 5=Other, 1000=Stakeholder, 1001=Sales Team, 1002=Service)

    .PARAMETER Description
    Connection role description. Optional.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created connectionrole record.

    .EXAMPLE
    $roleRef = New-XrmConnectionRole -Name "Project Manager" -Category 1;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/describe-relationship-entities-connection-roles
#>
function New-XrmConnectionRole {
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

        [Parameter(Mandatory = $false)]
        [int]
        $Category,

        [Parameter(Mandatory = $false)]
        [string]
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "connectionrole" -Attributes @{
            "name" = $Name;
        };

        if ($PSBoundParameters.ContainsKey('Category')) {
            $record["category"] = New-XrmOptionSetValue -Value $Category;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $record["description"] = $Description;
        }

        $record.Id = $XrmClient | Add-XrmRecord -Record $record;
        $record.ToEntityReference();
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmConnectionRole -Alias *;
