<#
    .SYNOPSIS
    Create a polymorphic lookup attribute in Microsoft Dataverse.

    .DESCRIPTION
    Create a polymorphic lookup column that can reference multiple table types using the CreatePolymorphicLookupAttribute SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Lookup
    The LookupAttributeMetadata defining the polymorphic lookup column.

    .PARAMETER OneToManyRelationships
    Array of OneToManyRelationshipMetadata objects defining each target entity relationship.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the polymorphic lookup to.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The CreatePolymorphicLookupAttribute response.

    .EXAMPLE
    $lookup = [Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata]::new();
    $lookup.SchemaName = "new_RegardingId";
    $lookup.DisplayName = New-XrmLabel -Text "Regarding";

    $rel1 = [Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata]::new();
    $rel1.SchemaName = "new_account_regarding";
    $rel1.ReferencedEntity = "account";
    $rel1.ReferencingEntity = "new_custom";

    $rel2 = [Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata]::new();
    $rel2.SchemaName = "new_contact_regarding";
    $rel2.ReferencedEntity = "contact";
    $rel2.ReferencingEntity = "new_custom";

    New-XrmPolymorphicLookup -Lookup $lookup -OneToManyRelationships @($rel1, $rel2);

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/define-alternate-keys-entity#create-polymorphic-lookup
#>
function New-XrmPolymorphicLookup {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata]
        $Lookup,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata[]]
        $OneToManyRelationships,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "CreatePolymorphicLookupAttribute";
        $request = $request | Add-XrmRequestParameter -Name "Lookup" -Value $Lookup;
        $request = $request | Add-XrmRequestParameter -Name "OneToManyRelationships" -Value $OneToManyRelationships;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $request = $request | Add-XrmRequestParameter -Name "SolutionUniqueName" -Value $SolutionUniqueName;
        }

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmPolymorphicLookup -Alias *;
