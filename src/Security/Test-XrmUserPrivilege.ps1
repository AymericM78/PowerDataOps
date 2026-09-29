<#
    .SYNOPSIS
    Check whether a user holds a privilege.

    .DESCRIPTION
    Ask the platform whether the user holds the privilege through their security roles (RetrieveUserPrivilegeByPrivilegeName), optionally at a minimum depth.
    Raises an error when the privilege does not exist.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER PrivilegeName
    Privilege name (e.g. "prvBypassCustomPlugins", "prvReadAccount").

    .PARAMETER UserId
    System user unique identifier. (Default: current user)

    .PARAMETER Depth
    Minimum depth (Basic < Local < Deep < Global). (Default: any depth)

    .OUTPUTS
    System.Boolean. True when the user holds the privilege (at the minimum depth, if given).

    .EXAMPLE
    if (-not (Test-XrmUserPrivilege -XrmClient $xrmClient -PrivilegeName "prvBypassCustomPlugins")) {
        throw "The migration account cannot bypass plug-ins.";
    }

    .EXAMPLE
    $canReadAll = Test-XrmUserPrivilege -XrmClient $xrmClient -PrivilegeName "prvReadAccount" -UserId $user.Id -Depth Global;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmUserPrivilege.md
#>
function Test-XrmUserPrivilege {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PrivilegeName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $UserId,

        [Parameter(Mandatory = $false)]
        [Microsoft.Crm.Sdk.Messages.PrivilegeDepth]
        $Depth
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if (-not $PSBoundParameters.ContainsKey('UserId')) {
            $UserId = Get-XrmWhoAmI -XrmClient $XrmClient;
        }

        $request = New-XrmRequest -Name "RetrieveUserPrivilegeByPrivilegeName";
        $request = $request | Add-XrmRequestParameter -Name "UserId" -Value $UserId;
        $request = $request | Add-XrmRequestParameter -Name "PrivilegeName" -Value $PrivilegeName;
        try {
            $response = $XrmClient | Invoke-XrmRequest -Request $request -ErrorAction Stop;
        }
        catch {
            throw "Cannot check privilege '$PrivilegeName' for user '$UserId': $($_.Exception.Message)";
        }

        $privileges = @($response.Results["RolePrivileges"]);
        if ($PSBoundParameters.ContainsKey('Depth')) {
            $privileges = @($privileges | Where-Object { [int]$_.Depth -ge [int]$Depth });
        }
        $privileges.Count -gt 0;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmUserPrivilege -Alias *;
