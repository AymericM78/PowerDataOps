<#
    .SYNOPSIS
    Core function for Az DevOps API consumption.
#>

# TODO : To review

<#
function Invoke-XrmDevOpsApi {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false)]
        [string]
        $OrganizationName = $Global:XrmContext.CurrentConnection.DevOpsSettings.OrganizationName,

        [Parameter(Mandatory = $false)]
        [string]
        $ProjectName = $Global:XrmContext.CurrentConnection.DevOpsSettings.ProjectName,

        [Parameter(Mandatory = $false)]
        [string]
        $Token = $Global:XrmContext.CurrentConnection.DevOpsSettings.Token,

        [Parameter(Mandatory = $true)]
        [string]
        $RelativeApiUrl,

        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method,
        
        [Parameter(Mandatory = $false)]
        [string]
        $Body,

        [Parameter(Mandatory = $false)]
        [string]
        $ApiVersion = "5.1-preview.1",

        [Parameter(Mandatory = $false)]
        [string]
        $ContentType = "application/json; charset=UTF-8"
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {

        $projectName = $ProjectName.Replace(" ", "%20");

        $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$Token"));
        $headers = @{Authorization = ("Basic {0}" -f $encodedPat) };

        $apiUrl = "https://dev.azure.com/$OrganizationName/$projectName/_apis";
        if (-not $RelativeApiUrl.StartsWith('/')) {
            $apiUrl += '/';
        }
        $apiUrl += $RelativeApiUrl;
        if (-not $apiUrl.Contains("api-version")) {
            $operand = if ($apiUrl.Contains('?')) { '&' } else { '?' };
            $apiUrl += $operand + "api-version=$ApiVersion";
        }

        try {
            $result = Invoke-RestMethod -Uri $apiUrl -Method $Method -ContentType $ContentType -Body $Body -Headers $headers -ErrorVariable "requestError";
            return $result;
        }
        catch {
            throw "DevOps API call error : $RelativeApiUrl => (Error : $($_.Exception.Message) | Reason : $requestError)";
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Invoke-XrmDevOpsApi -Alias *;

#>