<#
    .SYNOPSIS
   Search for record with simple query.
#>
function Get-XrmRecord {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Entity])]
    param
    (        
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Key,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AttributeName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [Object]
        $Value,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {

        $columnSet = New-Object -TypeName Microsoft.Xrm.Sdk.Query.ColumnSet;                     
        if($PSBoundParameters.Columns)
        {
            if ($Columns.Contains("*")) {
                $columnSet.AllColumns = $true;
            }
            else {
                $Columns | ForEach-Object {
                    $columnSet.AddColumn($_);
                }
            }
        }
        
        if($PSBoundParameters.Key)
        {
            $request = New-Object -TypeName Microsoft.Xrm.Sdk.Messages.RetrieveRequest;
            $request.Target = New-XrmEntityReference -LogicalName $LogicalName -Key $Key -Value $Value;
            $request.ColumnSet = $columnSet;
            $response = $XrmClient.Execute($request);
            $response.Entity | ConvertTo-XrmObject;
        }
        elseif($PSBoundParameters.AttributeName)
        {
            $query = New-XrmQueryExpression -LogicalName $LogicalName -TopCount 1;
            $query.ColumnSet = $columnSet;
            $query | Add-XrmQueryCondition -Field $AttributeName -Condition Equal -Values $Value | Out-Null;
            $result = $XrmClient | Get-XrmMultipleRecords -Query $query;

            $result | Select-Object -First 1;
        }
        else {  
            $result = Protect-XrmCommand -ScriptBlock { $XrmClient.Retrieve($LogicalName, $Value, $columnSet) };
            $result | ConvertTo-XrmObject;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmRecord -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmRecord -ParameterName "LogicalName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*"};
}

Register-ArgumentCompleter -CommandName Get-XrmRecord -ParameterName "AttributeName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    if (-not ($fakeBoundParameters.ContainsKey("LogicalName")))
    {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.LogicalName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*"};
}

Register-ArgumentCompleter -CommandName Get-XrmRecord -ParameterName "Columns" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    if (-not ($fakeBoundParameters.ContainsKey("LogicalName")))
    {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.LogicalName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*"};
}

