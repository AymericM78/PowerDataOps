<#
    .SYNOPSIS
    Create a one-to-many relationship in Microsoft Dataverse.

    .DESCRIPTION
    Create a 1:N relationship using CreateOneToManyRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER OneToManyRelationship
    The OneToManyRelationshipMetadata object defining the relationship.

    .PARAMETER Lookup
    The LookupAttributeMetadata for the lookup column created on the many side.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the relationship to.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The CreateOneToMany response.

    .EXAMPLE
    $rel = [Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata]::new();
    $rel.SchemaName = "new_account_contact";
    $rel.ReferencedEntity = "account";
    $rel.ReferencingEntity = "contact";
    $rel.ReferencedAttribute = "accountid";
    $lookup = [Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata]::new();
    $lookup.SchemaName = "new_AccountId";
    $lookup.DisplayName = New-XrmLabel -Text "Account";
    Add-XrmOneToManyRelationship -OneToManyRelationship $rel -Lookup $lookup;
#>
function Add-XrmOneToManyRelationship {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata]
        $OneToManyRelationship,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata]
        $Lookup,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.CreateOneToManyRequest]::new();
        $request.OneToManyRelationship = $OneToManyRelationship;
        $request.Lookup = $Lookup;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $request.Parameters["SolutionUniqueName"] = $SolutionUniqueName;
        }

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmOneToManyRelationship -Alias *;
