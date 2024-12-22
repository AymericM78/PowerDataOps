<#
    .SYNOPSIS
    Initialize new object that represent a Xrm Context.

    .DESCRIPTION
    Core module cmdlet that create new object to store context information.
#>
function New-XrmContext {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,
  
        [Parameter(Mandatory = $false)]
        [String]
        [ValidateNotNullOrEmpty()]
        $ConnectionString
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $hash = @{ };
        $hash["UserId"] = [guid]::Empty;
        $hash["IsOnPremise"] = $false;
        $hash["IsOnline"] = $false;
        $hash["IsAdminConnected"] = $false;
        $hash["IsUserConnected"] = $false;
        $hash["IsDevOps"] = ($null -ne $ENV:SYSTEM_COLLECTIONID);
        $hash["CurrentConnection"] = New-XrmConnection;
        $hash["CurrentInstance"] = $null;
        $hash["CurrentUrl"] = $null;
        $hash["IsEncrypted"] = $false;

        $object = New-Object PsObject -Property $hash;
        if ($PSBoundParameters.ContainsKey('ConnectionString')) {
            $object.CurrentConnection = New-XrmConnection -ConnectionString $ConnectionString;
        }
        if ($PSBoundParameters.ContainsKey('XrmClient')) {
            
            $object.IsUserConnected = $XrmClient.IsReady;
            $object.CurrentInstance = $XrmClient.OrganizationDetail;
            $object.CurrentUrl = $XrmClient.ConnectedOrgPublishedEndpoints["WebApplication"];
            $object.IsOnline = $object.CurrentUrl.Contains('.dynamics.com');        
            $object.IsOnPremise = -not $object.IsOnline;

            $object.CurrentConnection.TenantId = $XrmClient.TenantId;
            $object.CurrentConnection.Name = $XrmClient.OrganizationDetail.UrlName;
            $object.CurrentConnection.Region = $XrmClient.OrganizationDetail.Geo;

            $userId = Get-XrmWhoAmI -XrmClient $XrmClient;
            $object.UserId = $userId;
        }

        $object;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmContext -Alias *;