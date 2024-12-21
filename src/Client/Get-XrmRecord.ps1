<#
    .SYNOPSIS
    Search for record with simple query.

    .Description
    Get specific row (Entity record) according to given id, key, or attribute.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER LogicalName
    Table / Entity logical name.

    .PARAMETER Key
    Specify alternate key attribute name to search.

    .PARAMETER AttributeName
    Specify attribute name to search.

    .PARAMETER Value
    Specify key or attribute value to search.
    Use Id to specify row (entity record) unique identifier

    .PARAMETER Columns
    Specify row (entity record) columns to return. (array)

    .OUTPUTS
    Custom Object. Row (= Entity record) is converted to custom object to simplify data operations.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $contosoAccount = Get-XrmRecord -XrmClient $xrmClient -LogicalName "account" -AttributeName "name" -Value "Contoso" -Columns "revenue";
    Write-Host $contosoAccount.revenue;

    .LINK
    Samples: https://github.com/AymericM78/PowerDataOps/blob/main/documentation/samples/Working%20with%20data.md
#>
function Get-XrmRecord {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
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
        if ($PSBoundParameters.Columns) {
            if ($Columns.Contains("*")) {
                $columnSet.AllColumns = $true;
            }
            else {
                $Columns | ForEach-Object {
                    $columnSet.AddColumn($_);
                }
            }
        }
        
        if ($PSBoundParameters.Key) {
            $request = New-Object -TypeName Microsoft.Xrm.Sdk.Messages.RetrieveRequest;
            $request.Target = New-XrmEntityReference -LogicalName $LogicalName -Key $Key -Value $Value;
            $request.ColumnSet = $columnSet;
            $response = $XrmClient.Execute($request);
            $response.Entity | ConvertTo-XrmObject;
        }
        elseif ($PSBoundParameters.AttributeName) {
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
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

Register-ArgumentCompleter -CommandName Get-XrmRecord -ParameterName "AttributeName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    if (-not ($fakeBoundParameters.ContainsKey("LogicalName"))) {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.LogicalName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}

Register-ArgumentCompleter -CommandName Get-XrmRecord -ParameterName "Columns" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    if (-not ($fakeBoundParameters.ContainsKey("LogicalName"))) {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.LogicalName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}

