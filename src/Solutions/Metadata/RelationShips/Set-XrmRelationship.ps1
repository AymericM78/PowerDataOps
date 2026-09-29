<#
    .SYNOPSIS
    Update the cascading behavior or the navigation menu of a relationship.

    .DESCRIPTION
    Read the relationship, apply the given settings and send it back (UpdateRelationship).
    CascadeConfiguration and AssociatedMenuConfiguration apply to one-to-many relationships; Entity1AssociatedMenuConfiguration and Entity2AssociatedMenuConfiguration to many-to-many ones.
    Only the properties set on the given configurations change (see New-XrmCascadeConfiguration, New-XrmAssociatedMenuConfiguration): the others keep their current value.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Relationship schema name.

    .PARAMETER CascadeConfiguration
    Cascading behavior (1:N).

    .PARAMETER AssociatedMenuConfiguration
    Navigation menu of the related rows on the parent form (1:N).

    .PARAMETER Entity1AssociatedMenuConfiguration
    Navigation menu on the first table of a N:N relationship.

    .PARAMETER Entity2AssociatedMenuConfiguration
    Navigation menu on the second table of a N:N relationship.

    .PARAMETER MergeLabels
    Keep the labels of the languages that are not given. (Default: true)

    .PARAMETER SolutionUniqueName
    Unmanaged solution to add the relationship to.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. UpdateRelationship response.

    .EXAMPLE
    Set-XrmRelationship -XrmClient $xrmClient -Name "new_project_task" -CascadeConfiguration (New-XrmCascadeConfiguration -Delete Restrict -Assign NoCascade);

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmRelationship.md
#>
function Set-XrmRelationship {
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
        $Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.CascadeConfiguration]
        $CascadeConfiguration,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.AssociatedMenuConfiguration]
        $AssociatedMenuConfiguration,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.AssociatedMenuConfiguration]
        $Entity1AssociatedMenuConfiguration,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.AssociatedMenuConfiguration]
        $Entity2AssociatedMenuConfiguration,

        [Parameter(Mandatory = $false)]
        [bool]
        $MergeLabels = $true,

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
        $relationship = Get-XrmRelationship -XrmClient $XrmClient -Name $Name -IfExists;
        if (-not $relationship) {
            throw "Relationship '$Name' not found.";
        }
        $isOneToMany = $relationship -is [Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata];
        if ($isOneToMany -and ($PSBoundParameters.ContainsKey('Entity1AssociatedMenuConfiguration') -or $PSBoundParameters.ContainsKey('Entity2AssociatedMenuConfiguration'))) {
            throw "Relationship '$Name' is one-to-many: use CascadeConfiguration or AssociatedMenuConfiguration.";
        }
        if (-not $isOneToMany -and ($PSBoundParameters.ContainsKey('CascadeConfiguration') -or $PSBoundParameters.ContainsKey('AssociatedMenuConfiguration'))) {
            throw "Relationship '$Name' is many-to-many: use Entity1AssociatedMenuConfiguration or Entity2AssociatedMenuConfiguration.";
        }

        # Copy the properties set on the given configuration onto the current one
        $copySetProperties = {
            param($source, $target)
            foreach ($property in $source.GetType().GetProperties()) {
                if (-not $property.CanWrite -or $property.Name -eq "ExtensionData") {
                    continue;
                }
                $value = $property.GetValue($source);
                if ($null -ne $value) {
                    $property.SetValue($target, $value);
                }
            }
        };
        if ($PSBoundParameters.ContainsKey('CascadeConfiguration')) {
            & $copySetProperties $CascadeConfiguration $relationship.CascadeConfiguration;
        }
        if ($PSBoundParameters.ContainsKey('AssociatedMenuConfiguration')) {
            & $copySetProperties $AssociatedMenuConfiguration $relationship.AssociatedMenuConfiguration;
        }
        if ($PSBoundParameters.ContainsKey('Entity1AssociatedMenuConfiguration')) {
            & $copySetProperties $Entity1AssociatedMenuConfiguration $relationship.Entity1AssociatedMenuConfiguration;
        }
        if ($PSBoundParameters.ContainsKey('Entity2AssociatedMenuConfiguration')) {
            & $copySetProperties $Entity2AssociatedMenuConfiguration $relationship.Entity2AssociatedMenuConfiguration;
        }

        $request = [Microsoft.Xrm.Sdk.Messages.UpdateRelationshipRequest]::new();
        $request.Relationship = $relationship;
        $request.MergeLabels = $MergeLabels;
        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $request.Parameters["SolutionUniqueName"] = $SolutionUniqueName;
        }
        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmRelationship -Alias *;

Register-ArgumentCompleter -CommandName Set-XrmRelationship -ParameterName "SolutionUniqueName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}
