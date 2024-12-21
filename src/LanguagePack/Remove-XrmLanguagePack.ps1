<#
    .SYNOPSIS
    Desactivate given language 

    .DESCRIPTION
    Uninstall specify language pack from target instance.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
    
    .PARAMETER Language
    Language name LCID (English = 1033, French = 1036, ...)
#>
function Remove-XrmLanguagePack {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [int]
        $Language 
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {

        $provisionLanguageRequest = New-XrmRequest -Name "DeprovisionLanguage";
        $provisionLanguageRequest | Add-XrmRequestParameter -Name "Language" -Value $Language | Out-Null;

        $XrmClient | Set-XrmClientTimeout -DurationInMinutes 30;
        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $provisionLanguageRequest;
        $XrmClient | Set-XrmClientTimeout -Revert;
        $response;                
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Remove-XrmLanguagePack -Alias *;