<#
    .SYNOPSIS
    Create entity record in Microsoft Dataverse.

    .Description
    Add a new row in Microsoft Dataverse table and return created ID (Uniqueidentifier).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Record
    Record information to add. (Entity)

    .PARAMETER BypassCustomPluginExecution
    Specify wether involved plugins should be triggered or not during this operation. (Default: False)

    .OUTPUTS
    Guid. Newly created record identified.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $account = New-XrmEntity -LogicalName "account" -Attributes @{
        "name" = "Contoso";
        "revenue" = New-XrmMoney -Value 123456.78;
        "industrycode" = New-XrmOptionSetValue -Value 37;
    }
    $account.Id = Add-XrmRecord -XrmClient $xrmClient -Record $account;

    .LINK
    Samples: https://github.com/AymericM78/PowerDataOps/blob/main/documentation/samples/Working%20with%20data.md
#>
function Add-XrmRecord {
    [CmdletBinding()]
    [OutputType([Guid])]
    param
    (    
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.Entity]
        $Record,

        [Parameter(Mandatory = $false)]
        [switch]
        $BypassCustomPluginExecution = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {

        $request = New-XrmRequest -Name "Create";
        $request | Add-XrmRequestParameter -Name "Target" -Value $Record | Out-Null;
        if ($BypassCustomPluginExecution) {
            $request | Add-XrmRequestParameter -Name "BypassCustomPluginExecution" -Value $true | Out-Null;
        }

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $id = $response.Results["id"];
        $id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmRecord -Alias *;