<#
    .SYNOPSIS
    Create a PrincipalAccess object.

    .DESCRIPTION
    Instantiate a Microsoft.Crm.Sdk.Messages.PrincipalAccess object with the specified principal and access rights.

    .PARAMETER Principal
    User or team entity reference.

    .PARAMETER AccessRights
    Access rights to grant. Default: ReadAccess + WriteAccess + AppendAccess + AppendToAccess.

    .OUTPUTS
    Microsoft.Crm.Sdk.Messages.PrincipalAccess.

    .EXAMPLE
    $principalAccess = New-XrmPrincipalAccess -Principal $userRef -AccessRights ([Microsoft.Crm.Sdk.Messages.AccessRights]::ReadAccess);
#>
function New-XrmPrincipalAccess {
    [CmdletBinding()]
    [OutputType("Microsoft.Crm.Sdk.Messages.PrincipalAccess")]
    param
    (        
        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $Principal,

        [Parameter(Mandatory = $false)]
        [Microsoft.Crm.Sdk.Messages.AccessRights]
        $AccessRights = ([Microsoft.Crm.Sdk.Messages.AccessRights]::ReadAccess -bor [Microsoft.Crm.Sdk.Messages.AccessRights]::WriteAccess -bor [Microsoft.Crm.Sdk.Messages.AccessRights]::AppendAccess -bor [Microsoft.Crm.Sdk.Messages.AccessRights]::AppendToAccess)
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $principalAccess = New-Object "Microsoft.Crm.Sdk.Messages.PrincipalAccess";
        $principalAccess.AccessMask = $AccessRights;
        $principalAccess.Principal = $Principal;
        $principalAccess;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmPrincipalAccess -Alias *;
