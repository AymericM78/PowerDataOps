<#
    .SYNOPSIS
    Send an email record.

    .DESCRIPTION
    Send a Dataverse email activity record using the SendEmail SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EmailReference
    Entity reference of the email activity record to send.

    .PARAMETER IssueSend
    Whether to issue the send operation. (Default: true)

    .PARAMETER TrackingToken
    Optional tracking token for the email.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $emailRef = New-XrmEntityReference -LogicalName "email" -Id $emailId;
    Send-XrmEmail -XrmClient $xrmClient -EmailReference $emailRef;
#>
function Send-XrmEmail {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $EmailReference,

        [Parameter(Mandatory = $false)]
        [bool]
        $IssueSend = $true,

        [Parameter(Mandatory = $false)]
        [string]
        $TrackingToken = ""
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $request = New-XrmRequest -Name "SendEmail";
        $request | Add-XrmRequestParameter -Name "EmailId" -Value $EmailReference.Id | Out-Null;
        $request | Add-XrmRequestParameter -Name "IssueSend" -Value $IssueSend | Out-Null;
        $request | Add-XrmRequestParameter -Name "TrackingToken" -Value $TrackingToken | Out-Null;
        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Send-XrmEmail -Alias *;
