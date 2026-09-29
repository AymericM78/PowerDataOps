<#
    .SYNOPSIS
    Set entity attribute value.

    .DESCRIPTION
    Add or update attribute value.
    The value is normalized for the SDK: the PowerShell PSObject adapter (objects built with New-Object or emitted by a pipeline) is removed, and a homogeneous Object[] is typed. Without this, the request fails at serialization.

    .PARAMETER Record
    Entity record / table row (Entity).

    .PARAMETER Name
    Attribute (Column) name.

    .PARAMETER Value
    Attribute value object.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Entity. The updated record, for pipeline chaining.

    .EXAMPLE
    $record = New-XrmEntity -LogicalName "account";
    $record = $record | Set-XrmAttributeValue -Name "name" -Value "Contoso";
#>
function Set-XrmAttributeValue {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Entity])]
    param
    (        
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Entity]
        $Record,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $false)]
        [System.Object]
        $Value
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        $sdkValue = ConvertTo-XrmSdkValueInternal -Value $Value;
        $Record[$Name] = $sdkValue;
        $Record;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmAttributeValue -Alias *;


Register-ArgumentCompleter -CommandName Set-XrmAttributeValue -ParameterName "Name" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $record = $null;
    if (-not ($FakeBoundParameters.ContainsKey("Record"))) {
        # TODO : Search record  for logicalname in Pipeline
        return @();
    }
    else {
        $record = $FakeBoundParameters.Record;         
    }

    $validAttributeNames = @($record.Attributes.Keys);
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}