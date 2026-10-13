<#
    Integration Test: Connection & WhoAmI
    Validates that the module connects to the target Dataverse instance, and that an interactive sign-in fails at once in a non-interactive session (K10).
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

# 4. Interactive sign-in where nobody can answer it (K10): fail at once instead of waiting for the timeout
Write-Section "Interactive sign-in in a non-interactive session";
$moduleScope = Get-Module PowerDataOps;
Assert-Test "-NonInteractive detected" { (& $moduleScope { Get-XrmNonInteractiveReasonInternal -CommandLineArgs @("pwsh", "-NoProfile", "-NonInteractive", "-Command", "x") -UserInteractive $true -HostName "ConsoleHost" }) -like "*-NonInteractive*" };
Assert-Test "Abbreviated -noni detected" { (& $moduleScope { Get-XrmNonInteractiveReasonInternal -CommandLineArgs @("powershell.exe", "-noni", "-c", "x") -UserInteractive $true -HostName "ConsoleHost" }) -like "*-NonInteractive*" };
Assert-Test "-NonInteractive after -File belongs to the script" { $null -eq (& $moduleScope { Get-XrmNonInteractiveReasonInternal -CommandLineArgs @("pwsh", "-File", "deploy.ps1", "-NonInteractive") -UserInteractive $true -HostName "ConsoleHost" }) };
Assert-Test "No user desktop detected" { (& $moduleScope { Get-XrmNonInteractiveReasonInternal -CommandLineArgs @("pwsh") -UserInteractive $false -HostName "ConsoleHost" }) -like "*desktop*" };
Assert-Test "Remote session detected" { (& $moduleScope { Get-XrmNonInteractiveReasonInternal -CommandLineArgs @("pwsh") -UserInteractive $true -HostName "ServerRemoteHost" }) -like "*remote*" };
Assert-Test "Interactive console: no reason" { $null -eq (& $moduleScope { Get-XrmNonInteractiveReasonInternal -CommandLineArgs @("pwsh", "-NoProfile") -UserInteractive $true -HostName "ConsoleHost" }) };
Assert-Test "Prompt expected: OAuth without password, secret or certificate" { & $moduleScope { Test-XrmConnectionStringPromptInternal -ConnectionString (Resolve-XrmClientConnectionStringInternal -ConnectionString "Url=https://contoso.crm.dynamics.com") } };
Assert-Test "No prompt: LoginPrompt=Never, client secret, password" {
    & $moduleScope {
        -not (Test-XrmConnectionStringPromptInternal -ConnectionString "AuthType=OAuth;Url=https://contoso.crm.dynamics.com;LoginPrompt=Never") -and
        -not (Test-XrmConnectionStringPromptInternal -ConnectionString "AuthType=ClientSecret;Url=https://contoso.crm.dynamics.com;ClientId=a;ClientSecret=b") -and
        -not (Test-XrmConnectionStringPromptInternal -ConnectionString "AuthType=OAuth;Url=https://contoso.crm.dynamics.com;Username=a;Password=b");
    };
};

# End to end, in a child pwsh started with -NonInteractive (killed if it ever waits)
$modulePath = (Resolve-Path "$PSScriptRoot\..\..\PowerDataOps.psd1").Path;
$command = "Import-Module '$modulePath' -DisableNameChecking 6>`$null | Out-Null; try { New-XrmClient -ConnectionString 'Url=https://powerdataops.crm12.dynamics.com/' -Quiet | Out-Null; 'PDO-CONNECTED' } catch { 'PDO-ERROR:' + `$_.Exception.Message }";
$outputPath = [System.IO.Path]::GetTempFileName();
$stopWatch = [System.Diagnostics.Stopwatch]::StartNew();
$process = Start-Process -FilePath "pwsh" -ArgumentList @("-NoProfile", "-NonInteractive", "-EncodedCommand", [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($command))) -RedirectStandardOutput $outputPath -NoNewWindow -PassThru;
$exited = $process.WaitForExit(120000);
$stopWatch.Stop();
if (-not $exited) { $process.Kill($true); }
$childOutput = Get-Content -Path $outputPath -Raw;
Remove-Item -Path $outputPath -Force -ErrorAction SilentlyContinue;
Assert-Test "pwsh -NonInteractive: New-XrmClient fails at once with an actionable message ($([int]$stopWatch.Elapsed.TotalSeconds) s)" {
    $exited -and $childOutput -like "*PDO-ERROR:*Interactive sign-in is not possible*client secret*" -and $stopWatch.Elapsed.TotalSeconds -lt 60;
};

Write-TestSummary;
