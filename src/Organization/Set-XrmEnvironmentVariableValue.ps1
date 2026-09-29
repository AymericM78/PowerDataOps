<#
    .SYNOPSIS
    Set environment variable value.

    .DESCRIPTION
    Create or update the current value of a Dataverse environment variable by its schema name.
    Nothing is written when the current value (override) already equals Value (case-sensitive comparison).
    Use Remove-XrmEnvironmentVariableValue to remove the override and go back to the default value.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Environment variable definition schema name.

    .PARAMETER Value
    Value to set for the environment variable.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Entity reference of the created or updated environment variable value record.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    Set-XrmEnvironmentVariableValue -XrmClient $xrmClient -Name "df_SynchTrackingFunctionUrl" -Value "https://myfunc.azurewebsites.net/api/execute";
#>
function Set-XrmEnvironmentVariableValue {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]
        $Value
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
        $definitionId = $variable.DefinitionId;

        if ($variable.HasOverride) {
            $valueReference = New-XrmEntityReference -LogicalName "environmentvariablevalue" -Id $variable.ValueId;
            # Same value: nothing to write
            if ([string]$variable.Value -ceq $Value) {
                return $valueReference;
            }
            $updateRecord = New-XrmEntity -LogicalName "environmentvariablevalue" -Id $variable.ValueId -Attributes @{
                "value" = $Value;
            };
            Update-XrmRecord -XrmClient $XrmClient -Record $updateRecord;
            $valueReference;
        }
        else {
            # Create new value
            $newRecord = New-XrmEntity -LogicalName "environmentvariablevalue" -Attributes @{
                "environmentvariabledefinitionid" = New-XrmEntityReference -LogicalName "environmentvariabledefinition" -Id $definitionId;
                "value" = $Value;
            };
            $newId = Add-XrmRecord -XrmClient $XrmClient -Record $newRecord;
            if ($newId) {
                New-XrmEntityReference -LogicalName "environmentvariablevalue" -Id $newId;
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmEnvironmentVariableValue -Alias *;
