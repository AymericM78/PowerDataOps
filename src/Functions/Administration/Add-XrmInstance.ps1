<#
    .SYNOPSIS
    Create new Dataverse instance.
#>
function Add-XrmInstance {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [String]
        $InstanceDisplayName,

        [Parameter(Mandatory)]
        [String]
        $InstanceDomainName,

        [Parameter(Mandatory=$true)]
        [ArgumentCompleter( { Get-XrmRegions })]
        [String]
        $Location,

        [Parameter(Mandatory=$true)]
        [ValidateSet("Sandbox", "Production")]
        [String]
        $Sku,

        [Parameter(Mandatory=$true)]
        [String]
        $CurrencyCodeName,

        [Parameter(Mandatory=$true)]
        [int]
        $Lcid,

        [Parameter(Mandatory=$false)]
        [String[]]
        $Templates
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
        Assert-XrmAdminConnected;
    }    
    process {    
        $response = New-AdminPowerAppEnvironment -DisplayName $InstanceDisplayName -DomainName $InstanceDomainName -Location $Location -EnvironmentSku $Sku -CurrencyName $CurrencyCodeName -LanguageName $Lcid -Templates $Templates -ProvisionDatabase -WaitUntilFinished $true;
        if($response.Code)
        {
            throw "$($response.Error.code) : $($response.Error.message)";
        }
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmInstance -Alias *;