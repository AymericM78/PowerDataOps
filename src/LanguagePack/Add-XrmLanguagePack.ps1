<#
    .SYNOPSIS
    Activate given language.

    .DESCRIPTION
    Install specify language pack to target instance.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
    
    .PARAMETER Language
    Language name LCID (English = 1033, French = 1036, ...)
#>
function Add-XrmLanguagePack {
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

        # TODO : Move to async 
        # https://docs.microsoft.com/en-us/dynamics365/customer-engagement/web-api/provisionlanguageasync?view=dynamics-ce-odata-9

        $provisionLanguageRequest = New-XrmRequest -Name "ProvisionLanguage";
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

Export-ModuleMember -Function Add-XrmLanguagePack -Alias *;