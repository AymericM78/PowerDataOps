<#
    .SYNOPSIS
    Create or update an environment variable definition.

    .DESCRIPTION
    Find the environment variable definition by schema name; create it when missing, else update the given properties (display name, default value, description).
    The type is set at creation only. With SolutionUniqueName, the definition is added to the solution (idempotent).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SchemaName
    Schema name of the definition, with the publisher prefix (e.g. "new_ApiUrl").

    .PARAMETER DisplayName
    Display name. (Default: SchemaName, at creation)

    .PARAMETER Type
    Data type, at creation: String, Number, Boolean, JSON, DataSource, Secret. (Default: String)

    .PARAMETER DefaultValue
    Default value of the variable. An empty string clears it.

    .PARAMETER Description
    Description of the variable.

    .PARAMETER SolutionUniqueName
    Unmanaged solution to add the definition to.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference of the definition.

    .EXAMPLE
    $definition = Upsert-XrmEnvironmentVariableDefinition -XrmClient $xrmClient -SchemaName "new_ApiUrl" -DisplayName "API URL" -DefaultValue "https://api.contoso.com" -SolutionUniqueName "MySolution";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmEnvironmentVariableDefinition.md
#>
function Upsert-XrmEnvironmentVariableDefinition {
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
        $SchemaName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $false)]
        [ValidateSet("String", "Number", "Boolean", "JSON", "DataSource", "Secret")]
        [String]
        $Type = "String",

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [String]
        $DefaultValue,

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [String]
        $Description,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $typeCodes = @{ "String" = 100000000; "Number" = 100000001; "Boolean" = 100000002; "JSON" = 100000003; "DataSource" = 100000004; "Secret" = 100000005 };

        $attributes = @{};
        if ($PSBoundParameters.ContainsKey('DisplayName')) { $attributes["displayname"] = $DisplayName; }
        if ($PSBoundParameters.ContainsKey('DefaultValue')) { $attributes["defaultvalue"] = $DefaultValue; }
        if ($PSBoundParameters.ContainsKey('Description')) { $attributes["description"] = $Description; }

        $existing = $XrmClient | Get-XrmRecord -LogicalName "environmentvariabledefinition" -AttributeName "schemaname" -Value $SchemaName -AsEntity;
        if ($existing) {
            $definitionId = $existing.Id;
            if ($attributes.Count -gt 0) {
                $XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "environmentvariabledefinition" -Id $definitionId -Attributes $attributes);
            }
        }
        else {
            $attributes["schemaname"] = $SchemaName;
            $attributes["type"] = New-XrmOptionSetValue -Value $typeCodes[$Type];
            if (-not $attributes.ContainsKey("displayname")) { $attributes["displayname"] = $SchemaName; }
            $definitionId = $XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "environmentvariabledefinition" -Attributes $attributes);
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName') -and $definitionId) {
            $componentType = $XrmClient | Get-XrmSolutionComponentType -LogicalName "environmentvariabledefinition";
            $XrmClient | Add-XrmSolutionComponent -SolutionUniqueName $SolutionUniqueName -ComponentId $definitionId -ComponentType $componentType | Out-Null;
        }

        if ($definitionId) {
            New-XrmEntityReference -LogicalName "environmentvariabledefinition" -Id $definitionId;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmEnvironmentVariableDefinition -Alias *;
