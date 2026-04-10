<#
    .SYNOPSIS
    Create an alternate key on a Microsoft Dataverse table.

    .DESCRIPTION
    Add a new entity key using CreateEntityKeyRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.

    .PARAMETER EntityKeyMetadata
    The EntityKeyMetadata object defining the alternate key.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the alternate key to.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The CreateEntityKey response.

    .EXAMPLE
    $key = [Microsoft.Xrm.Sdk.Metadata.EntityKeyMetadata]::new();
    $key.LogicalName = "new_accountcode";
    $key.DisplayName = New-XrmLabel -Text "Account Code";
    $key.KeyAttributes = @("new_code");
    New-XrmAlternateKey -EntityLogicalName "account" -EntityKeyMetadata $key;
#>
function New-XrmAlternateKey {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.EntityKeyMetadata]
        $EntityKeyMetadata,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = [Microsoft.Xrm.Sdk.Messages.CreateEntityKeyRequest]::new();
        $request.EntityName = $EntityLogicalName;
        $request.EntityKey = $EntityKeyMetadata;

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

Export-ModuleMember -Function New-XrmAlternateKey -Alias *;
