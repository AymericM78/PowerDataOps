<#
    .SYNOPSIS
    Remove active customizations.

    .DESCRIPTION 
    Performs a cleaning on Active Layer to remove unmanaged customizations for given component.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
    
    .PARAMETER SolutionUniqueName
    Solution unique name where to get components to clean.
    
    .PARAMETER ComponentId
    Solution component unique identifier to clean.
#>
function Remove-XrmActiveCustomizations {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionComponentName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $ComponentId
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
            Write-HostAndLog -Message $_.Exception.Message -MethodName "Remove-XrmActiveCustomizations" -Level WARN;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Remove-XrmActiveCustomizations -Alias *;