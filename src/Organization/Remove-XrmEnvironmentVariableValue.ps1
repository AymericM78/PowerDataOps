<#
    .SYNOPSIS
    Remove the value (override) of an environment variable.

    .DESCRIPTION
    Delete the value record of an environment variable, so that the default value of its definition applies again.
    Nothing is done when the variable has no value record.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Environment variable definition schema name.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Remove-XrmEnvironmentVariableValue -XrmClient $xrmClient -Name "new_ApiUrl";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmEnvironmentVariableValue.md
#>
function Remove-XrmEnvironmentVariableValue {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $variable = Get-XrmEnvironmentVariablesInternal -XrmClient $XrmClient -Name $Name | Select-Object -First 1;
        if (-not $variable) {
            throw "Environment variable definition '$Name' not found.";
        }
        if ($variable.HasOverride) {
            $XrmClient | Remove-XrmRecord -LogicalName "environmentvariablevalue" -Id $variable.ValueId;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmEnvironmentVariableValue -Alias *;
