<#
    .SYNOPSIS
    Initialize EntityReference object instance.
#>
function New-XrmEntityReference {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.EntityReference")]
    param
    (        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Key,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [Object]
        $Value
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {

        if ($Key) {
            [Microsoft.Xrm.Sdk.EntityReference] (New-Object -TypeName "Microsoft.Xrm.Sdk.EntityReference" -ArgumentList $LogicalName, $Key, $Value);
        }
        else {
            [Microsoft.Xrm.Sdk.EntityReference] (New-Object -TypeName "Microsoft.Xrm.Sdk.EntityReference" -ArgumentList $LogicalName, ([Guid] $Value));
        }        
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmEntityReference -Alias *;

Register-ArgumentCompleter -CommandName New-XrmEntityReference -ParameterName "LogicalName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*"};
}