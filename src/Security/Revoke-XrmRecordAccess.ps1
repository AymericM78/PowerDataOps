<#
    .SYNOPSIS
    Revoke access on a record for a user or team.

    .DESCRIPTION
    Remove all granted access rights on a Dataverse record for a specified principal (user or team).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER PrincipalReference
    User or team entity reference to revoke access from.

    .PARAMETER TargetReference
    Target record entity reference to unshare.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $userRef = New-XrmEntityReference -LogicalName "systemuser" -Id $userId;
    $accountRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
    Revoke-XrmRecordAccess -XrmClient $xrmClient -PrincipalReference $userRef -TargetReference $accountRef;
#>
function Revoke-XrmRecordAccess {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $PrincipalReference,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $TargetReference
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $request = New-XrmRequest -Name "RevokeAccess";
        $request | Add-XrmRequestParameter -Name "Target" -Value $TargetReference | Out-Null;
        $request | Add-XrmRequestParameter -Name "Revokee" -Value $PrincipalReference | Out-Null;
        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Revoke-XrmRecordAccess -Alias *;
