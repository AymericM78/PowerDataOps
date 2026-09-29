<#
    .SYNOPSIS
    Search for record with simple query.

    .Description
    Get specific row (Entity record) according to given id, key, attribute, or set of attributes.
    With AttributeName or Attributes, the first matching row is returned ($null when none matches); Unique raises an error when several rows match.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

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

    .PARAMETER Attributes
    Hashtable of column = value conditions, all required (AND). A $null value matches an empty column; an EntityReference, OptionSetValue or Money value is compared on its id or value.

    .PARAMETER IfExists
    Return $null when the row does not exist (search by id or key), instead of raising an error.

    .PARAMETER Unique
    With AttributeName or Attributes: raise an error when more than one row matches, instead of returning the first one.

    .PARAMETER AsEntity
    Return the SDK Entity instead of a converted custom object.

    .OUTPUTS
    Custom Object. Row (= Entity record) is converted to custom object to simplify data operations. With AsEntity: Microsoft.Xrm.Sdk.Entity.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $contosoAccount = Get-XrmRecord -XrmClient $xrmClient -LogicalName "account" -AttributeName "name" -Value "Contoso" -Columns "revenue";
    Write-Host $contosoAccount.revenue;

    .EXAMPLE
    $contact = Get-XrmRecord -XrmClient $xrmClient -LogicalName "contact" -Attributes @{ firstname = "John"; lastname = "Doe"; parentcustomerid = $accountRef } -Unique;

    .EXAMPLE
    $account = Get-XrmRecord -XrmClient $xrmClient -LogicalName "account" -Id $accountId -Columns "name" -IfExists;
    if (-not $account) { Write-Host "Deleted meanwhile"; }

    .LINK
    Samples: https://github.com/AymericM78/PowerDataOps/blob/main/documentation/samples/Working%20with%20data.md
#>
function Get-XrmRecord {
    [CmdletBinding(DefaultParameterSetName = "Value")]
    [OutputType([PSCustomObject], [Microsoft.Xrm.Sdk.Entity])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline, Position = 0)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogicalName,

        [Parameter(Mandatory = $false, ParameterSetName = "Value", Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Key,

        [Parameter(Mandatory = $false, ParameterSetName = "Value", Position = 3)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AttributeName,

        [Parameter(Mandatory = $true, ParameterSetName = "Value", Position = 4)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [Object]
        $Value,

        [Parameter(Mandatory = $false, Position = 5)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns,

        [Parameter(Mandatory = $true, ParameterSetName = "Attributes")]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Attributes,

        [Parameter(Mandatory = $false)]
        [switch]
        $IfExists,

        [Parameter(Mandatory = $false)]
        [switch]
        $Unique,

        [Parameter(Mandatory = $false)]
        [switch]
        $AsEntity
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

        $record = $null;
        if ($PSCmdlet.ParameterSetName -eq "Attributes" -or $PSBoundParameters.AttributeName) {
            $conditions = if ($PSCmdlet.ParameterSetName -eq "Attributes") { $Attributes } else { @{ $AttributeName = $Value } };

            $query = New-XrmQueryExpression -LogicalName $LogicalName -TopCount $(if ($Unique) { 2 } else { 1 });
            $query.ColumnSet = $columnSet;
            foreach ($field in $conditions.Keys) {
                $conditionValue = $conditions[$field];
                if ($conditionValue -is [Microsoft.Xrm.Sdk.EntityReference]) { $conditionValue = $conditionValue.Id; }
                elseif ($conditionValue -is [Microsoft.Xrm.Sdk.OptionSetValue]) { $conditionValue = $conditionValue.Value; }
                elseif ($conditionValue -is [Microsoft.Xrm.Sdk.Money]) { $conditionValue = $conditionValue.Value; }

                if ($null -eq $conditionValue) {
                    $query | Add-XrmQueryCondition -Field $field -Condition Null | Out-Null;
                }
                else {
                    $query | Add-XrmQueryCondition -Field $field -Condition Equal -Values $conditionValue | Out-Null;
                }
            }
            $rows = $XrmClient | Get-XrmMultipleRecords -Query $query -AsEntity -AsArray;

            if ($Unique -and $rows.Count -gt 1) {
                $criteria = ($conditions.Keys | ForEach-Object { "$_ = '$($conditions[$_])'" }) -join ", ";
                throw "More than one '$LogicalName' row matches $criteria.";
            }
            $record = $rows | Select-Object -First 1;
        }
        elseif ($PSBoundParameters.Key) {
            $request = New-Object -TypeName Microsoft.Xrm.Sdk.Messages.RetrieveRequest;
            $request.Target = New-XrmEntityReference -LogicalName $LogicalName -Key $Key -Value $Value;
            $request.ColumnSet = $columnSet;
            if ($IfExists) {
                try {
                    $response = $XrmClient | Invoke-XrmRequest -Request $request;
                }
                catch {
                    if (Test-XrmNotFoundError -ErrorRecord $_) {
                        return $null;
                    }
                    throw;
                }
            }
            else {
                $response = $XrmClient | Invoke-XrmRequest -Request $request;
            }
            $record = $response.Entity;
        }
        else {
            if ($IfExists) {
                try {
                    $record = Protect-XrmCommand -ScriptBlock { $XrmClient.Retrieve($LogicalName, $Value, $columnSet) };
                }
                catch {
                    if (Test-XrmNotFoundError -ErrorRecord $_) {
                        return $null;
                    }
                    throw;
                }
            }
            else {
                $record = Protect-XrmCommand -ScriptBlock { $XrmClient.Retrieve($LogicalName, $Value, $columnSet) };
            }
        }

        if ($null -eq $record) {
            return $null;
        }
        if ($AsEntity) {
            return $record;
        }
        $record | ConvertTo-XrmObject;
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

