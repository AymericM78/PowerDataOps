<#
    Integration Test: request options and -AsRequest (brief lot 3a)
    Set-XrmRequestOptions, and the options / -AsRequest of Add-, Update-, Upsert-, Remove-XrmRecord and Set-XrmRecordState.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$prefix = Get-TestName -Prefix "Options";
$createdIds = [System.Collections.Generic.List[Guid]]::new();

# ============================================================
# Set-XrmRequestOptions
# ============================================================
Write-Section "Set-XrmRequestOptions";

$stepId = [Guid]::NewGuid();
$request = New-XrmRequest -Name "Create";
$request = $request | Set-XrmRequestOptions -BypassBusinessLogicExecution CustomSync, CustomAsync -BypassBusinessLogicExecutionStepIds $stepId -SuppressCallbackRegistrationExpanderJob -SuppressDuplicateDetection -Tag "pdo" -BypassCustomPluginExecution;
Assert-Test "BypassBusinessLogicExecution = 'CustomSync,CustomAsync'" { $request.Parameters["BypassBusinessLogicExecution"] -eq "CustomSync,CustomAsync" };
Assert-Test "BypassBusinessLogicExecutionStepIds = step id" { $request.Parameters["BypassBusinessLogicExecutionStepIds"] -eq $stepId.ToString() };
Assert-Test "SuppressCallbackRegistrationExpanderJob, SuppressDuplicateDetection, BypassCustomPluginExecution = true" {
    $request.Parameters["SuppressCallbackRegistrationExpanderJob"] -eq $true -and $request.Parameters["SuppressDuplicateDetection"] -eq $true -and $request.Parameters["BypassCustomPluginExecution"] -eq $true;
};
Assert-Test "Tag stored under 'tag'" { $request.Parameters["tag"] -eq "pdo" };

$plain = New-XrmRequest -Name "Create" | Set-XrmRequestOptions;
Assert-Test "No option given: nothing added" { $plain.Parameters.Count -eq 0 };

# ============================================================
# -AsRequest
# ============================================================
Write-Section "-AsRequest";

$record = New-XrmEntity -LogicalName "account" -Attributes @{ name = "$prefix-asrequest" };
$createRequest = Add-XrmRecord -XrmClient $Global:XrmClient -Record $record -BypassBusinessLogicExecution CustomSync -Tag "pdo" -AsRequest;
Assert-Test "Add-XrmRecord -AsRequest: CreateRequest with target and options" {
    $createRequest -is [Microsoft.Xrm.Sdk.Messages.CreateRequest] -and $createRequest.Target["name"] -eq "$prefix-asrequest" -and $createRequest.Parameters["BypassBusinessLogicExecution"] -eq "CustomSync" -and $createRequest.Parameters["tag"] -eq "pdo";
};
$notCreated = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -AttributeName "name" -Value "$prefix-asrequest";
Assert-Test "Add-XrmRecord -AsRequest: nothing sent" { $null -eq $notCreated };

$updateRequest = Update-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Id ([Guid]::NewGuid()) -Attributes @{ name = "x" }) -AsRequest;
$upsertRequest = Upsert-XrmRecord -Record $record -AsRequest;
$deleteRequest = Remove-XrmRecord -LogicalName "account" -Id ([Guid]::NewGuid()) -AsRequest;
$stateRequest = Set-XrmRecordState -RecordReference (New-XrmEntityReference -LogicalName "account" -Id ([Guid]::NewGuid())) -StateCode 1 -StatusCode 2 -SuppressCallbackRegistrationExpanderJob -AsRequest;
Assert-Test "Update / Upsert / Remove -AsRequest: typed requests" {
    $updateRequest -is [Microsoft.Xrm.Sdk.Messages.UpdateRequest] -and $upsertRequest -is [Microsoft.Xrm.Sdk.Messages.UpsertRequest] -and $deleteRequest -is [Microsoft.Xrm.Sdk.Messages.DeleteRequest] -and $deleteRequest.Target.LogicalName -eq "account";
};
Assert-Test "Set-XrmRecordState -AsRequest: UpdateRequest with statecode, statuscode and options" {
    $stateRequest -is [Microsoft.Xrm.Sdk.Messages.UpdateRequest] -and $stateRequest.Target["statecode"].Value -eq 1 -and $stateRequest.Target["statuscode"].Value -eq 2 -and $stateRequest.Parameters["SuppressCallbackRegistrationExpanderJob"] -eq $true;
};

# ============================================================
# Options sent to the platform
# ============================================================
Write-Section "Options accepted by the platform";

$accountId = $Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Attributes @{ name = "$prefix-sent" }) -BypassBusinessLogicExecution CustomSync, CustomAsync -SuppressCallbackRegistrationExpanderJob -SuppressDuplicateDetection -Tag "pdo";
Assert-Test "Add-XrmRecord with every option: created" { $accountId -is [Guid] -and $accountId -ne [Guid]::Empty };
$createdIds.Add($accountId);

$Global:XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Id $accountId -Attributes @{ description = "updated" }) -BypassBusinessLogicExecution CustomSync -SuppressCallbackRegistrationExpanderJob;
$Global:XrmClient | Upsert-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Id $accountId -Attributes @{ telephone1 = "0102030405" }) -BypassBusinessLogicExecution CustomAsync -Tag "pdo" | Out-Null;
$stateReference = $Global:XrmClient | Set-XrmRecordState -RecordReference (New-XrmEntityReference -LogicalName "account" -Id $accountId) -StateCode 1 -StatusCode 2 -BypassBusinessLogicExecution CustomSync;
$check = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $accountId -Columns "description", "telephone1", "statecode";
Assert-Test "Update, Upsert and Set-XrmRecordState with options: applied" {
    $check.description -eq "updated" -and $check.telephone1 -eq "0102030405" -and ($check | Get-XrmRowValue -Name "statecode" -Raw) -eq 1;
};
Assert-Test "Set-XrmRecordState still returns the reference" { $stateReference.Id -eq $accountId };

Write-Section "Requests built with -AsRequest, sent in bulk";

$bulkRequests = 1..3 | ForEach-Object { Add-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Attributes @{ name = "$prefix-bulk-$_" }) -BypassBusinessLogicExecution CustomSync -AsRequest };
$bulkResponses = @($Global:XrmClient | Invoke-XrmBulkRequests -Requests $bulkRequests -ReturnResponses $true -Quiet);
$bulkResponses | ForEach-Object { $createdIds.Add($_.Results["id"]); };
Assert-Test "3 accounts created from -AsRequest requests" { $bulkResponses.Count -eq 3 };

Write-Section "Remove-XrmRecord with options";
$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $accountId -BypassBusinessLogicExecution CustomSync -SuppressCallbackRegistrationExpanderJob;
$createdIds.Remove($accountId) | Out-Null;
Assert-Test "Deleted" { $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $accountId -IfExists) };

Write-Section "Cleanup";
foreach ($id in $createdIds) { try { $Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $id; } catch { } }
Assert-Test "Cleanup complete" { $true };

Write-TestSummary;
