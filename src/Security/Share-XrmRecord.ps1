<#
    .SYNOPSIS
    Share a record with a user or team.

    .DESCRIPTION
    Grant access rights on a Dataverse record to a specified principal (user or team).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER TargetReference
    Target record entity reference to share.

    .PARAMETER PrincipalAccess
    PrincipalAccess object created via New-XrmPrincipalAccess.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $userRef = New-XrmEntityReference -LogicalName "systemuser" -Id $userId;
    $accountRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
    $principalAccess = New-XrmPrincipalAccess -Principal $userRef;
    Share-XrmRecord -XrmClient $xrmClient -TargetReference $accountRef -PrincipalAccess $principalAccess;
#>
function Share-XrmRecord {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $TargetReference,

        [Parameter(Mandatory = $true)]
        [Microsoft.Crm.Sdk.Messages.PrincipalAccess]
        $PrincipalAccess
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $request = New-XrmRequest -Name "GrantAccess";
        $request | Add-XrmRequestParameter -Name "Target" -Value $TargetReference | Out-Null;
        $request | Add-XrmRequestParameter -Name "PrincipalAccess" -Value $PrincipalAccess | Out-Null;
        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Share-XrmRecord -Alias *;
