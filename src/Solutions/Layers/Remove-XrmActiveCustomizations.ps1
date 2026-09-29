<#
    .SYNOPSIS
    Remove active customizations.

    .DESCRIPTION
    Performs a cleaning on Active Layer to remove unmanaged customizations for given component.
    Returns the RemoveActiveCustomizations response. A failure raises an error, except a "not found" error when IgnoreMissing is set (a warning is written and $null is returned).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionComponentName
    Solution component type name, as returned by Get-XrmSolutionComponentName (e.g. "SavedQuery", "SystemForm", "WebResource").

    .PARAMETER ComponentId
    Solution component unique identifier to clean.

    .PARAMETER IgnoreMissing
    Do not raise an error when the component or its active layer cannot be found.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The RemoveActiveCustomizations response ($null when ignored).

    .EXAMPLE
    $response = Remove-XrmActiveCustomizations -XrmClient $xrmClient -SolutionComponentName "SavedQuery" -ComponentId $viewId;

    .EXAMPLE
    Remove-XrmActiveCustomizations -XrmClient $xrmClient -SolutionComponentName "SystemForm" -ComponentId $formId -IgnoreMissing | Out-Null;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmActiveCustomizations.md
#>
function Remove-XrmActiveCustomizations {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionComponentName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $ComponentId,

        [Parameter(Mandatory = $false)]
        [switch]
        $IgnoreMissing
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        $removeActiveCustomizationsRequest = New-XrmRequest -Name "RemoveActiveCustomizations";
        $removeActiveCustomizationsRequest = $removeActiveCustomizationsRequest | Add-XrmRequestParameter -Name "SolutionComponentName" -Value $SolutionComponentName;
        $removeActiveCustomizationsRequest = $removeActiveCustomizationsRequest | Add-XrmRequestParameter -Name "ComponentId" -Value $ComponentId;

        try {
            $response = $XrmClient | Invoke-XrmRequest -Request $removeActiveCustomizationsRequest;
        }
        catch {
            if ($IgnoreMissing -and (Test-XrmNotFoundError -ErrorRecord $_)) {
                Write-HostAndLog -Message "Remove-XrmActiveCustomizations: $SolutionComponentName '$ComponentId' ignored: $($_.Exception.Message)" -Level WARN;
                return $null;
            }
            throw [System.InvalidOperationException]::new("Cannot remove active customizations of $SolutionComponentName '$ComponentId': $($_.Exception.Message)", $_.Exception);
        }
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmActiveCustomizations -Alias *;
