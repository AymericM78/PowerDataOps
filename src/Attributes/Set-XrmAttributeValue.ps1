<#
    .SYNOPSIS
    Set entity attribute value.

    .DESCRIPTION
    Add or update attribute value.

    .PARAMETER Record
    Entity record / table row (Entity).

    .PARAMETER Name
    Attribute (Column) name.

    .PARAMETER Name
    Attribute value object.
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
        $Record[$Name] = $Value;              
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