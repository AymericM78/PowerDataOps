<#
    .SYNOPSIS
    Set environment variable value.

    .DESCRIPTION
    Create or update the current value of a Dataverse environment variable by its schema name.

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
    [CmdletBinding()]
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
        # Retrieve the environment variable definition
        $definitionQuery = New-XrmQueryExpression -LogicalName "environmentvariabledefinition" -Columns "environmentvariabledefinitionid", "schemaname" -TopCount 1;
        $definitionQuery | Add-XrmQueryCondition -Field "schemaname" -Condition Equal -Values $Name | Out-Null;
        $definitions = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $definitionQuery;
        $definition = $definitions | Select-Object -First 1;

        if (-not $definition) {
            throw "Environment variable definition '$Name' not found.";
        }

        $definitionId = $definition.environmentvariabledefinitionid;

        # Check if a value record already exists
        $valueQuery = New-XrmQueryExpression -LogicalName "environmentvariablevalue" -Columns "environmentvariablevalueid", "value" -TopCount 1;
        $valueQuery | Add-XrmQueryCondition -Field "environmentvariabledefinitionid" -Condition Equal -Values $definitionId | Out-Null;
        $existingValues = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $valueQuery;
        $existingValue = $existingValues | Select-Object -First 1;

        if ($existingValue) {
            # Update existing value
            $updateRecord = New-XrmEntity -LogicalName "environmentvariablevalue" -Id $existingValue.environmentvariablevalueid -Attributes @{
                "value" = $Value;
            };
            Update-XrmRecord -XrmClient $XrmClient -Record $updateRecord;
            New-XrmEntityReference -LogicalName "environmentvariablevalue" -Id $existingValue.environmentvariablevalueid;
        }
        else {
            # Create new value
            $newRecord = New-XrmEntity -LogicalName "environmentvariablevalue" -Attributes @{
                "environmentvariabledefinitionid" = New-XrmEntityReference -LogicalName "environmentvariabledefinition" -Id $definitionId;
                "value" = $Value;
            };
            $newId = Add-XrmRecord -XrmClient $XrmClient -Record $newRecord;
            New-XrmEntityReference -LogicalName "environmentvariablevalue" -Id $newId;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmEnvironmentVariableValue -Alias *;
