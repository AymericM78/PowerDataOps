<#!
    Integration Test: Set-XrmLocalizedLabel cmdlet
    Validates setting localized labels (LocalizedLabel[]) via the SetLocLabels SDK message.
    SetLocLabels targets records of customization entities (savedquery, systemform, ...),
    so we set the localized 'name' on a savedquery and assert the request is accepted.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Set Localized Label on a savedquery";

# Create a temporary system view on account to use as a SetLocLabels target.
$viewName = Get-TestName -Prefix "LocLabelView";
$fetchXml = "<fetch><entity name='account'><attribute name='name' /></entity></fetch>";
$layoutXml = "<grid name='resultset' object='1' jump='name' select='1' icon='1' preview='1'><row name='result' id='accountid'><cell name='name' width='300' /></row></grid>";

$viewRef = $Global:XrmClient | Add-XrmView -EntityLogicalName "account" -Name $viewName -FetchXml $fetchXml -LayoutXml $layoutXml;
Assert-Test "Temp view created" { $viewRef -ne $null -and $viewRef.Id -ne [Guid]::Empty };

# Set localized labels — this is the path that previously failed with
# "Input field type 'Label' does not match expected type 'LocalizedLabel[]'".
$labels = @{ 1036 = "Nom FR test"; 1033 = "Name EN test" };
$response = $Global:XrmClient | Set-XrmLocalizedLabel -EntityMoniker $viewRef -AttributeName "name" -Labels $labels;
Assert-Test "SetLocLabels accepted (LocalizedLabel[] sent)" { $response -ne $null };

Write-Section "Cleanup";
$Global:XrmClient | Remove-XrmRecord -LogicalName "savedquery" -Id $viewRef.Id;

Write-TestSummary;
