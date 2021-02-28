<#
    .SYNOPSIS
    Create new Dataverse instance.

    .DESCRIPTION
    Provision new dataverse instance with database.

    .PARAMETER InstanceDisplayName
    Instance friendly name

    .PARAMETER InstanceDomainName
    Instance domain name for instance url (myinstance => myinstance.crm.dynamics1.com)

    .PARAMETER Location
    DataCenter region (France, EMEA, UK, ...)

    .PARAMETER Sku
    Instance type (sandbox or production)

    .PARAMETER CurrencyCodeName
    Name of currency (EUR, ...)
    
    .PARAMETER LanguageName
    Language name LCID (English = 1033, French = 1036, ...)
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

        [Parameter(Mandatory = $true)]
        [ArgumentCompleter( { Get-XrmRegions })]
        [String]
        $Location,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Sandbox", "Production")]
        [String]
        $Sku,

        [Parameter(Mandatory = $true)]
        [ArgumentCompleter( { Get-AdminPowerAppCdsDatabaseCurrencies })]
        [String]
        $CurrencyCodeName,

        [Parameter(Mandatory = $true)]
        [ArgumentCompleter( { Get-AdminPowerAppCdsDatabaseLanguages  })]
        [String]
        $LanguageName
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
        Assert-XrmAdminConnected;
    }    
    process {    
        $response = New-AdminPowerAppEnvironment -DisplayName $InstanceDisplayName -DomainName $InstanceDomainName -Location $Location -EnvironmentSku $Sku -CurrencyName $CurrencyCodeName -LanguageName $LanguageName -ProvisionDatabase -WaitUntilFinished $true;
        if ($response.Code) {
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