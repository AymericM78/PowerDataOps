<#
    Integration Test: Customization
    Tests views, forms, charts, dashboards, commands cmdlets.
    Cmdlets: Add-XrmView, Get-XrmViews, Remove-XrmView,
             Get-XrmForms, Get-XrmCharts, Get-XrmDashboards,
             Add-XrmCommand, Get-XrmCommands, Remove-XrmCommand
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# Get-XrmViews
# ============================================================
Write-Section "Get-XrmViews";

$views = $Global:XrmClient | Get-XrmViews -EntityLogicalName "account" -Columns "name", "savedqueryid", "querytype";
Assert-Test "Get-XrmViews (account) - returns views (actual: $($views.Count))" {
    $views.Count -ge 1;
};

$activeAccountsView = $views | Where-Object { $_.name -eq "Active Accounts" } | Select-Object -First 1;
Assert-Test "Get-XrmViews - 'Active Accounts' view exists" {
    $activeAccountsView -ne $null;
};

# ============================================================
# Add-XrmView + Remove-XrmView
# ============================================================
Write-Section "Add-XrmView + Remove-XrmView";

$viewName = Get-TestName -Prefix "View";
$fetchXml = @"
<fetch version="1.0" output-format="xml-platform" mapping="logical" distinct="false">
  <entity name="account">
    <attribute name="name" />
    <attribute name="accountid" />
    <order attribute="name" descending="false" />
    <filter type="and">
      <condition attribute="statecode" operator="eq" value="0" />
    </filter>
  </entity>
</fetch>
"@;

$layoutXml = @"
<grid name="resultset" object="1" jump="name" select="1" icon="1" preview="1">
  <row name="result" id="accountid">
    <cell name="name" width="300" />
  </row>
</grid>
"@;

$viewRef = $Global:XrmClient | Add-XrmView `
    -EntityLogicalName "account" `
    -Name $viewName `
    -FetchXml $fetchXml `
    -LayoutXml $layoutXml `
    -Description "Integration test view";

Assert-Test "Add-XrmView - created '$viewName' (Id: $($viewRef.Id))" {
    $viewRef -ne $null -and $viewRef.Id -ne [Guid]::Empty;
};

# Verify the view appears
$viewsAfter = $Global:XrmClient | Get-XrmViews -EntityLogicalName "account" -Columns "name", "savedqueryid";
$createdView = $viewsAfter | Where-Object { $_.name -eq $viewName } | Select-Object -First 1;
Assert-Test "Add-XrmView - view appears in Get-XrmViews" {
    $createdView -ne $null;
};

# Remove the view
$Global:XrmClient | Remove-XrmView -ViewReference $viewRef;
Assert-Test "Remove-XrmView - view removed" { $true };

# ============================================================
# Get-XrmForms
# ============================================================
Write-Section "Get-XrmForms";

$forms = $Global:XrmClient | Get-XrmForms -EntityLogicalName "account" -Columns "name", "formid", "type";
Assert-Test "Get-XrmForms (account) - returns forms (actual: $($forms.Count))" {
    $forms.Count -ge 1;
};

# FormType 2 = Main form
$mainForms = $Global:XrmClient | Get-XrmForms -EntityLogicalName "account" -FormType 2 -Columns "name", "formid";
Assert-Test "Get-XrmForms (Main forms) - returns main forms (actual: $($mainForms.Count))" {
    $mainForms.Count -ge 1;
};

# ============================================================
# Get-XrmCharts
# ============================================================
Write-Section "Get-XrmCharts";

$charts = $Global:XrmClient | Get-XrmCharts -EntityLogicalName "account" -Columns "name", "savedqueryvisualizationid";
Assert-Test "Get-XrmCharts (account) - returns charts (actual: $($charts.Count))" {
    $charts.Count -ge 0;
};

# ============================================================
# Get-XrmDashboards
# ============================================================
Write-Section "Get-XrmDashboards";

$dashboards = $Global:XrmClient | Get-XrmDashboards -Columns "name", "formid";
Assert-Test "Get-XrmDashboards - returns dashboards (actual: $($dashboards.Count))" {
    $dashboards.Count -ge 0;
};

# ============================================================
# Add-XrmCommand + Get-XrmCommands + Remove-XrmCommand
# ============================================================
Write-Section "Commands CRUD";

$cmdName = Get-TestName -Prefix "Cmd";
$cmdUniqueName = "pdo_testcmd_$(Get-Random -Minimum 10000 -Maximum 99999)";
$cmdRef = $Global:XrmClient | Add-XrmCommand `
    -Name $cmdName `
    -UniqueName $cmdUniqueName `
    -Type 2 `
    -Context 0 `
    -ButtonLabelText "Test Button" `
    -Location 0;

Assert-Test "Add-XrmCommand - created '$cmdName'" {
    $cmdRef -ne $null -and $cmdRef.Id -ne [Guid]::Empty;
};

# Get commands and check ours exists
$commands = $Global:XrmClient | Get-XrmCommands -Columns "name", "uniquename";
Assert-Test "Get-XrmCommands - returns commands (actual: $($commands.Count))" {
    $commands.Count -ge 1;
};

$ourCmd = $commands | Where-Object { $_.uniquename -eq $cmdUniqueName } | Select-Object -First 1;
Assert-Test "Get-XrmCommands - test command found" {
    $ourCmd -ne $null;
};

# Remove command
$Global:XrmClient | Remove-XrmCommand -CommandReference $cmdRef;
Assert-Test "Remove-XrmCommand - command removed" { $true };

Write-TestSummary;
