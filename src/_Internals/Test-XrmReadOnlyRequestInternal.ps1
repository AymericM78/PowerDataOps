<#
    Tell whether an organization request only reads data, so that Invoke-XrmRequest skips ShouldProcess for it
    (-WhatIf must not stop the reads a write cmdlet does before writing).
    Read-only: request names starting with Retrieve, Get, Validate, Download, Export, IsValid, Search, Query, Format,
    plus WhoAmI, FetchXmlToQueryExpression, InitializeFrom, InitializeFileBlocksDownload.
    ExecuteMultiple / ExecuteTransaction are read-only when every inner request is; ExecuteAsync follows its inner request.
    Any other request is treated as a write.
#>
function Test-XrmReadOnlyRequestInternal {
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.OrganizationRequest]
        $Request
    )

    $name = $Request.RequestName;
    if ($name -in @("ExecuteMultiple", "ExecuteTransaction")) {
        foreach ($innerRequest in $Request.Parameters["Requests"]) {
            if (-not (Test-XrmReadOnlyRequestInternal -Request $innerRequest)) {
                return $false;
            }
        }
        return $true;
    }
    if ($name -eq "ExecuteAsync") {
        return (Test-XrmReadOnlyRequestInternal -Request $Request.Parameters["Request"]);
    }
    if ($name -in @("WhoAmI", "FetchXmlToQueryExpression", "InitializeFrom", "InitializeFileBlocksDownload")) {
        return $true;
    }
    return ($name -match '^(Retrieve|Get|Validate|Download|Export|IsValid|Search|Query|Format)');
}
