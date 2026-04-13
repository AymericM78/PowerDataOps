<#
    Integration Test: Connection & WhoAmI
    Validates that the module connects to the target Dataverse instance.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Connection";

# 1. Client is connected
Assert-Test "XrmClient is ready" {
    $Global:XrmClient -ne $null -and $Global:XrmClient.IsReady;
};

# 2. Correct instance
$host_ = $Global:XrmClient.ConnectedOrgUriActual.Host;
Assert-Test "Connected to powerdataops.crm12.dynamics.com (actual: $host_)" {
    $host_ -eq "powerdataops.crm12.dynamics.com";
};

# 3. WhoAmI
Write-Section "WhoAmI";
$whoAmI = Get-XrmWhoAmI;
Assert-Test "WhoAmI returns a result" {
    $null -ne $whoAmI;
};
Assert-Test "UserId is not empty ($($whoAmI.UserId))" {
    $whoAmI.UserId -ne [Guid]::Empty;
};

Write-TestSummary;
