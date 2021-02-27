<#
    .SYNOPSIS
    Retrieve records from a view    
#>
function Get-XrmRecordsFromView {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityLogicalName,      

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ViewName
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {        
        $selectedView = Get-XrmViews -EntityLogicalName $EntityLogicalName -Columns "name", "layoutxml", "fetchxml" | Where-Object -Property "name" -EQ $ViewName;
        $fetchQuery = Get-XrmQueryFromFetch -FetchXml $selectedView.fetchxml;
        $records = Get-XrmMultipleRecords -Query $fetchQuery;
        $records;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmRecordsFromView -Alias *;

Register-ArgumentCompleter -CommandName New-XrmQueryExpression -ParameterName "EntityLogicalName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

Register-ArgumentCompleter -CommandName Get-XrmRecordsFromView -ParameterName "ViewName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $viewsNames = @();
    if (-not ($fakeBoundParameters.ContainsKey("EntityLogicalName"))) {
        return $viewsNames;
    }
    $views = Get-XrmViews -EntityLogicalName $fakeBoundParameters.EntityLogicalName -Columns "name";
    $views | ForEach-Object { $viewsNames += $_.name };
    return $viewsNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}