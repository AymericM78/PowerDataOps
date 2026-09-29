<#
    .SYNOPSIS
    Add parameter to request.

    .DESCRIPTION
    Add parameter name and value to given request.
    The value is normalized for the SDK: the PowerShell PSObject adapter is removed and a homogeneous Object[] is typed (e.g. @($query) becomes QueryExpression[]). A PSCustomObject or a hashtable cannot be sent to Dataverse and raises an error that names the parameter.

    .PARAMETER Request
    Organization request to complete.

    .PARAMETER Name
    Parameter name.

    .PARAMETER Value
    Parameter value. $null is accepted.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationRequest. The request, for pipeline chaining.

    .EXAMPLE
    $request = New-XrmRequest -Name "WhoAmI";
    $request = $request | Add-XrmRequestParameter -Name "Target" -Value $reference;
#>
function Add-XrmRequestParameter {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.OrganizationRequest")]
    param
    ( 
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.OrganizationRequest]
        $Request,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [AllowNull()]
        [object]
        $Value
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        if ($Request.Parameters.Contains($Name)) {
            throw "Request parameter '$Name' already added!"
        }

        $sdkValue = ConvertTo-XrmSdkValueInternal -Value $Value;
        if ($sdkValue -is [System.Management.Automation.PSCustomObject] -or $sdkValue -is [hashtable]) {
            throw "Request parameter '$Name': a value of type '$($sdkValue.GetType().Name)' cannot be sent to Dataverse. Pass an SDK type (Entity, EntityReference, OptionSetValue, typed array...).";
        }

        $Request.Parameters.Add($Name, $sdkValue);
        return $Request;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmRequestParameter -Alias *;