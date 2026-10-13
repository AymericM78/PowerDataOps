<#
    Integration Test: collection helpers (known issue K12)
    Split-XrmCollection and ForEach-ObjectWithProgress, with -Collection and through the pipeline (elements collected first). No Dataverse call.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# Split-XrmCollection
# ============================================================
Write-Section "Split-XrmCollection";

$chunks = @(Split-XrmCollection -Collection (1..5) -Count 2);
Assert-Test "-Collection: chunks of 2, 2 and 1" { $chunks.Count -eq 3 -and $chunks[0].Count -eq 2 -and $chunks[2].Count -eq 1 -and $chunks[2][0] -eq 5 };

$piped = @(1..5 | Split-XrmCollection -Count 2);
Assert-Test "Pipeline: same chunks as -Collection" { $piped.Count -eq 3 -and $piped[0].Count -eq 2 -and $piped[1][0] -eq 3 -and $piped[2].Count -eq 1 };

$small = @(Split-XrmCollection -Collection (1..3) -Count 10);
Assert-Test "Smaller than Count: one chunk with every element" { $small.Count -eq 1 -and $small[0].Count -eq 3 };

$streamed = [System.Collections.Generic.List[int]]::new();
1..5 | Split-XrmCollection -Count 2 | ForEach-Object { $streamed.Add($_.Count); };
Assert-Test "Each chunk reaches ForEach-Object as one array" { ($streamed -join ",") -eq "2,2,1" };

$pairs = @(@(1, 2), @(3, 4), @(5, 6));
$pipedArrays = @($pairs | Split-XrmCollection -Count 2);
Assert-Test "Piped arrays are kept whole: 2 chunks of pairs" { $pipedArrays.Count -eq 2 -and $pipedArrays[0].Count -eq 2 -and $pipedArrays[0][1][1] -eq 4 };

Assert-Test "Empty collection: no chunk" { @(Split-XrmCollection -Collection @() -Count 10).Count -eq 0 -and @(@() | Split-XrmCollection -Count 10).Count -eq 0 };

# ============================================================
# ForEach-ObjectWithProgress
# ============================================================
Write-Section "ForEach-ObjectWithProgress";

$results = ForEach-ObjectWithProgress -Collection @(1, 2, 3) -OperationName "Test" -ScriptBlock { param($item) $item * 10; };
Assert-Test "-Collection: script block output" { ($results -join ",") -eq "10,20,30" };

$pipedResults = 1, 2, 3 | ForEach-ObjectWithProgress -OperationName "Test" -ScriptBlock { param($item) $item * 10; };
Assert-Test "Pipeline: every element processed once" { ($pipedResults -join ",") -eq "10,20,30" };

$falsy = 0, $false, "" | ForEach-ObjectWithProgress -OperationName "Test" -ScriptBlock { param($item) "[$item]"; };
Assert-Test "Pipeline: 0, `$false and empty string are processed too" { ($falsy -join ",") -eq "[0],[False],[]" };

$arrayCounts = $pairs | ForEach-ObjectWithProgress -OperationName "Test" -ScriptBlock { param($item) $item.Count; };
Assert-Test "Pipeline: a piped array reaches the script block whole" { ($arrayCounts -join ",") -eq "2,2,2" };

# The progress shows the real total: Write-Progress is replaced, in the module scope only, by a function that records the status
$Global:PdoTestProgress = [System.Collections.Generic.List[string]]::new();
& (Get-Module PowerDataOps) {
    Set-Item -Path function:script:Write-Progress -Value { param($Id, $ParentId, $Activity, $Status, $PercentComplete, [switch]$Completed) if ($Status) { $Global:PdoTestProgress.Add($Status); } };
};
try {
    1, 2, 3 | ForEach-ObjectWithProgress -OperationName "Test" -ScriptBlock { param($item) } | Out-Null;
}
finally {
    & (Get-Module PowerDataOps) { Remove-Item -Path function:script:Write-Progress };
}
Assert-Test "Pipeline: progress counts 'of 3', not 'of 1'" { $Global:PdoTestProgress.Count -eq 3 -and $Global:PdoTestProgress[0] -like "*1 of 3*" -and $Global:PdoTestProgress[2] -like "*3 of 3*" };
Remove-Variable -Name PdoTestProgress -Scope Global;

Write-TestSummary;
