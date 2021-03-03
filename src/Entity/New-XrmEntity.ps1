<#
    .SYNOPSIS
    Initialize Entity object instance.

    .DESCRIPTION
    Create a new Microsoft Dataverse Entity object.

    .PARAMETER LogicalName
    Table / Entity logical name.

    .PARAMETER Id
    Record unique identifier.

    .PARAMETER Attributes
    Attributes array (Key value pair: logicalname = value).
#>
function New-XrmEntity {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.Entity")]
    param
    (        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]   
        [String]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]   
        [Guid]
        $Id,

        [Parameter(Mandatory = $false)]
        [Hashtable]
        $Attributes
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $record = New-Object -TypeName "Microsoft.Xrm.Sdk.Entity" -ArgumentList $LogicalName;
        if ($PSBoundParameters.ContainsKey('Id')) {
            $record.Id = $Id;
        }

        if ($PSBoundParameters.ContainsKey('Attributes')) {
            $Attributes.Keys | ForEach-Object {
                $key = $_;
                $value = $Attributes[$key];
                $record | Set-XrmAttributeValue -Name $key -Value $value | Out-Null;
            };
        }

        $record;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmEntity -Alias *;

Register-ArgumentCompleter -CommandName New-XrmEntity -ParameterName "LogicalName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}