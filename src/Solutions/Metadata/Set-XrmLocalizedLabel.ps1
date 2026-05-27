<#
    .SYNOPSIS
    Set localized labels on a Dataverse metadata component.

    .DESCRIPTION
    Update localized labels on a metadata attribute, entity, option value, or relationship using the SetLocLabels SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityMoniker
    EntityReference identifying the metadata component (e.g. EntityReference to an AttributeMetadata, EntityMetadata, etc.).

    .PARAMETER AttributeName
    The attribute within the metadata component to set the label for (e.g. "DisplayName", "Description").

    .PARAMETER Labels
    Hashtable of language code to label text. Example: @{ 1033 = "Account"; 1036 = "Compte" }

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The SetLocLabels response.

    .EXAMPLE
    $entityRef = New-XrmEntityReference -LogicalName "EntityMetadata" -Id $entityMetadataId;
    Set-XrmLocalizedLabel -EntityMoniker $entityRef -AttributeName "DisplayName" -Labels @{ 1033 = "Account"; 1036 = "Compte" };

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/setloclabels
#>
function Set-XrmLocalizedLabel {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $EntityMoniker,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $AttributeName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Labels
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        # SetLocLabels expects 'Labels' to be a LocalizedLabel[] (NOT a Label wrapper).
        # Build a strongly-typed array so the SDK ParameterCollection accepts it
        # (a raw PowerShell [object[]] would fail the type check).
        $localizedLabels = [System.Collections.Generic.List[Microsoft.Xrm.Sdk.LocalizedLabel]]::new();
        foreach ($langCode in $Labels.Keys) {
            $localizedLabels.Add((New-Object "Microsoft.Xrm.Sdk.LocalizedLabel" -ArgumentList @($Labels[$langCode], [int]$langCode)));
        }

        $request = New-XrmRequest -Name "SetLocLabels";
        $request | Add-XrmRequestParameter -Name "EntityMoniker" -Value $EntityMoniker | Out-Null;
        $request | Add-XrmRequestParameter -Name "AttributeName" -Value $AttributeName | Out-Null;
        $request | Add-XrmRequestParameter -Name "Labels" -Value $localizedLabels.ToArray() | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmLocalizedLabel -Alias *;
