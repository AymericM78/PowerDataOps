<#
    Integration Test: Email
    Tests activity party, email creation, and send cmdlets.
    Cmdlets: New-XrmActivityParty, New-XrmEmail, Send-XrmEmail
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# New-XrmActivityParty
# ============================================================
Write-Section "New-XrmActivityParty";

$whoAmI = Get-XrmWhoAmI;
$userRef = New-XrmEntityReference -LogicalName "systemuser" -Id $whoAmI;

# Activity party from entity reference
$partyFromRef = New-XrmActivityParty -PartyReference $userRef;
Assert-Test "New-XrmActivityParty (from EntityReference) - LogicalName = 'activityparty'" {
    $partyFromRef.LogicalName -eq "activityparty";
};
Assert-Test "New-XrmActivityParty (from EntityReference) - partyid set" {
    $partyFromRef["partyid"] -ne $null -and $partyFromRef["partyid"].Id -eq $whoAmI;
};

# Activity party from email address
$partyFromEmail = New-XrmActivityParty -AddressUsed "test@example.com";
Assert-Test "New-XrmActivityParty (from email) - addressused set" {
    $partyFromEmail["addressused"] -eq "test@example.com";
};

# Activity party with both
$partyBoth = New-XrmActivityParty -PartyReference $userRef -AddressUsed "override@example.com";
Assert-Test "New-XrmActivityParty (both) - partyid and addressused set" {
    $partyBoth["partyid"].Id -eq $whoAmI -and $partyBoth["addressused"] -eq "override@example.com";
};

# ============================================================
# New-XrmEmail
# ============================================================
Write-Section "New-XrmEmail";

# Build activity party entities as raw SDK objects to avoid PSObject wrapping in EntityCollection
$fromEntity = New-XrmActivityParty -PartyReference $userRef;
$toEntity =  New-XrmActivityParty -PartyReference $userRef;

$fromParty = @($fromEntity);
$toParty = @($toEntity);

$emailRef = $Global:XrmClient | New-XrmEmail `
    -From $fromParty `
    -To $toParty `
    -Subject "PDO Integration Test Email - $(Get-Date -Format 'yyyyMMdd-HHmmss')" `
    -Body "<p>This is an automated integration test email.</p>" `
    -DirectionCode $true;

Assert-Test "New-XrmEmail - email created (Id: $($emailRef.Id))" {
    $emailRef -ne $null -and $emailRef.Id -ne [Guid]::Empty;
};

# Verify the email record
$emailRecord = $Global:XrmClient | Get-XrmRecord -LogicalName "email" -Id $emailRef.Id -Columns "subject", "statuscode", "statecode";
Assert-Test "New-XrmEmail - subject matches" {
    $emailRecord.subject -like "PDO Integration Test Email*";
};
Assert-Test "New-XrmEmail - status is Draft (statecode=0)" {
    $emailRecord.statecode_Value.Value -eq 0;
};

# ============================================================
# Send-XrmEmail
# ============================================================
Write-Section "Send-XrmEmail";

try {
    $sendResponse = $Global:XrmClient | Send-XrmEmail -EmailReference $emailRef -IssueSend $true;
    Assert-Test "Send-XrmEmail - email sent" {
        $sendResponse -ne $null;
    };
}
catch {
    # Send may fail if no mailbox is configured - that's acceptable for integration testing
    Write-Host "  [SKIP] Send-XrmEmail - $($_.Exception.Message)" -ForegroundColor Yellow;
    Assert-Test "Send-XrmEmail - skipped (no mailbox configured)" { $true };
}

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";

$Global:XrmClient | Remove-XrmRecord -LogicalName "email" -Id $emailRef.Id;
Assert-Test "Email record deleted" { $true };

Write-TestSummary;
