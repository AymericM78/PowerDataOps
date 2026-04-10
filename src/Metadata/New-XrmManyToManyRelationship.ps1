<#
    .SYNOPSIS
    Create a many-to-many relationship in Microsoft Dataverse.

    .DESCRIPTION
    Create an N:N relationship using CreateManyToManyRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ManyToManyRelationship
    The ManyToManyRelationshipMetadata object defining the relationship.

    .PARAMETER IntersectEntityName
    Logical name for the intersect entity.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the relationship to.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The CreateManyToMany response.

    .EXAMPLE
    $rel = [Microsoft.Xrm.Sdk.Metadata.ManyToManyRelationshipMetadata]::new();
    $rel.SchemaName = "new_account_contact_nn";
    $rel.Entity1LogicalName = "account";
    $rel.Entity2LogicalName = "contact";
    New-XrmManyToManyRelationship -ManyToManyRelationship $rel -IntersectEntityName "new_account_contact";
#>
function New-XrmManyToManyRelationship {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.ManyToManyRelationshipMetadata]
        $ManyToManyRelationship,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $IntersectEntityName,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.CreateManyToManyRequest]::new();
        $request.ManyToManyRelationship = $ManyToManyRelationship;
        $request.IntersectEntityName = $IntersectEntityName;

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

Export-ModuleMember -Function New-XrmManyToManyRelationship -Alias *;
