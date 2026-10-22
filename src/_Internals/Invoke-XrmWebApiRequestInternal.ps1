<#
    Send one request to the Dataverse Web API (api/data/v9.2/<Path>) with the authentication of the client (ServiceClient.ExecuteWebRequest).
    Returns the body of the response as text, or as a JObject with AsJson (dates kept as text, so a definition read is sent back unchanged);
    $null when the body is empty, or when -WhatIf skips a write.
    Used where the organization service ignores a setting: the requirement level of an existing column (known issue K17).
    GET always runs; any other method writes and asks ShouldProcess, as Invoke-XrmRequest does for the SDK requests.
    StrongConsistency adds "Consistency: Strong": metadata read past the cache, which answers the previous definition for a while after a change.
    A failure raises an error naming the method, the path, the status and the message of the service.
#>
function Invoke-XrmWebApiRequestInternal {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low")]
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateSet("GET", "POST", "PATCH", "PUT", "DELETE")]
        [string]
        $Method,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter(Mandatory = $false)]
        [string]
        $Body,

        [Parameter(Mandatory = $false)]
        [Hashtable]
        $Headers = @{},

        [Parameter(Mandatory = $false)]
        [switch]
        $StrongConsistency,

        [Parameter(Mandatory = $false)]
        [switch]
        $AsJson
    )

    if ($Method -ne "GET" -and -not $PSCmdlet.ShouldProcess($Path, "Web API $Method")) {
        return $null;
    }

    $requestHeaders = @{} + $Headers;
    if ($StrongConsistency) {
        $requestHeaders["Consistency"] = "Strong";
    }
    $customHeaders = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.List[string]]]::new();
    foreach ($name in $requestHeaders.Keys) {
        $values = [System.Collections.Generic.List[string]]::new();
        $values.Add([string]$requestHeaders[$name]);
        $customHeaders[$name] = $values;
    }
    $content = $(if ($PSBoundParameters.ContainsKey('Body')) { $Body } else { $null });

    try {
        $response = Protect-XrmCommand -ScriptBlock { $XrmClient.ExecuteWebRequest([System.Net.Http.HttpMethod]::new($Method), $Path, $content, $customHeaders, "application/json", [System.Threading.CancellationToken]::None) };
    }
    catch {
        # HttpOperationException: the message of the service is in the body of the response
        $failure = $_.Exception;
        while ($null -ne $failure -and -not ($failure.PSObject.Properties["Response"] -and $null -ne $failure.Response -and $failure.Response.PSObject.Properties["StatusCode"])) {
            $failure = $failure.InnerException;
        }
        if ($null -eq $failure) {
            throw;
        }
        $serviceMessage = [string]$failure.Response.Content;
        try {
            $serviceMessage = ($serviceMessage | ConvertFrom-Json).error.message;
        }
        catch {
            # Not a Web API error body: keep it as is
        }
        throw [System.InvalidOperationException]::new("Web API $Method $Path failed ($([int]$failure.Response.StatusCode) $($failure.Response.StatusCode)): $serviceMessage", $failure);
    }
    if ($null -eq $response) {
        throw "Web API $Method $Path failed: no response ($($XrmClient.LastError)).";
    }

    $text = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
    if (-not $response.IsSuccessStatusCode) {
        throw "Web API $Method $Path failed ($([int]$response.StatusCode) $($response.StatusCode)): $text";
    }
    if ([string]::IsNullOrEmpty($text)) {
        return $null;
    }
    if (-not $AsJson) {
        return $text;
    }

    $reader = [Newtonsoft.Json.JsonTextReader]::new([System.IO.StringReader]::new($text));
    $reader.DateParseHandling = [Newtonsoft.Json.DateParseHandling]::None;
    # A JObject is enumerable: the comma keeps PowerShell from writing its properties one by one
    return , [Newtonsoft.Json.Linq.JObject]::Load($reader);
}
