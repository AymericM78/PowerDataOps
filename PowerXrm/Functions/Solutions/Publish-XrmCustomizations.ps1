<#
    .SYNOPSIS
    Publish customizations
#>
function Publish-XrmCustomizations {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ParameterXml,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $TimeOutInMinutes = 10
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $publishRequest =  New-Object -TypeName Microsoft.Crm.Sdk.Messages.PublishAllXmlRequest;
        if($ParameterXml)
        {
            $publishRequest = New-Object -TypeName Microsoft.Crm.Sdk.Messages.PublishXmlRequest;
            $publishRequest.ParameterXml = $ParameterXml;
        }

        # Run request with extended timeout
        $XrmClient | Set-XrmClientTimeout -DurationInMinutes $TimeOutInMinutes;
        $response = $XrmClient | Invoke-XrmRequest -Request $publishRequest;
        $XrmClient | Set-XrmClientTimeout -Revert;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Publish-XrmCustomizations -Alias *;