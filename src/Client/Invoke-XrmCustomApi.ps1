<#
    .SYNOPSIS
    Call a custom API (or any SDK message) by name.

    .DESCRIPTION
    Build the request from a hashtable of parameters, execute it and return the response.
    Values are passed as they are typed: EntityReference, Guid, int, OptionSetValue, arrays... (see Add-XrmRequestParameter). A bound custom API takes its record in the Target parameter.
    With JsonOutput, the named output parameter is read as JSON and the deserialized object is returned instead of the response ($null when the output is empty).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Custom API unique name (message name).

    .PARAMETER Parameters
    Request parameters, by name. (Default: none)

    .PARAMETER JsonOutput
    Name of an output parameter holding JSON to deserialize and return.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse, or PSCustomObject with JsonOutput.

    .EXAMPLE
    $response = Invoke-XrmCustomApi -XrmClient $xrmClient -Name "contoso_RecalculateScore" -Parameters @{ Target = $account.Reference; Force = $true };
    $response.Results["Score"];

    .EXAMPLE
    $result = Invoke-XrmCustomApi -XrmClient $xrmClient -Name "contoso_GetSettings" -JsonOutput "SettingsJson";
    $result.maxBatchSize;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmCustomApi.md
#>
function Invoke-XrmCustomApi {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse], [PSCustomObject])]
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
        [Hashtable]
        $Parameters,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $JsonOutput
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name $Name;
        if ($PSBoundParameters.ContainsKey('Parameters')) {
            foreach ($parameterName in $Parameters.Keys) {
                $request = $request | Add-XrmRequestParameter -Name $parameterName -Value $Parameters[$parameterName];
            }
        }

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        # Skipped by -WhatIf, or failed (the error is already written)
        if ($null -eq $response) {
            return;
        }
        if (-not $PSBoundParameters.ContainsKey('JsonOutput')) {
            return $response;
        }

        if (-not $response.Results.Contains($JsonOutput)) {
            throw "Custom API '$Name' has no output parameter '$JsonOutput'. Outputs: $(($response.Results.Keys) -join ', ').";
        }
        $json = [string]$response.Results[$JsonOutput];
        if ([string]::IsNullOrWhiteSpace($json)) {
            return $null;
        }
        $json | ConvertFrom-Json;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Invoke-XrmCustomApi -Alias *;
