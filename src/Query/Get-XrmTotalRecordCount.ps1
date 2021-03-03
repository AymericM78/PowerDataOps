<#
    .SYNOPSIS
    Returns total number of rows in given entity / table.

    .DESCRIPTION
    Returns data on the total number of records for specific entities. (RetrieveTotalRecordCount)

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER LogicalNames
    The logical names of the entities to include in the query.
#>
function Get-XrmTotalRecordCount {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]   
        [String[]]
        $LogicalNames
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        $retrieveTotalRecordCountRequest = New-XrmRequest -Name "RetrieveTotalRecordCount";
        $retrieveTotalRecordCountRequest | Add-XrmRequestParameter -Name "EntityNames" -Value $LogicalNames | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $retrieveTotalRecordCountRequest;
        $response.Results["EntityRecordCountCollection"];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmTotalRecordCount -Alias *;


Register-ArgumentCompleter -CommandName Get-XrmTotalRecordCount -ParameterName "LogicalNames" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
