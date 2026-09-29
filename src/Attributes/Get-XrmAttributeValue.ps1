<#
    .SYNOPSIS
    Read entity attribute.

    .DESCRIPTION
    Extract entity attribute value from record / table row.
    The record can be an Entity or a row returned by Get-XrmRecord / Get-XrmMultipleRecords (its Record property is read, so the value is the typed one, not the display label).
    A missing column, or a $null record, gives $null.
    Alias: Get-XrmRowValue. The alias always runs this command, even in a script that defines its own Get-XrmRowValue or Get-XrmAttributeValue function (PowerShell resolves an alias before a function).

    .PARAMETER Record
    Entity record / table row (Entity), or a row converted by the module (custom object with a Record property). $null is accepted. Alias: Row.

    .PARAMETER Name
    Attribute (Column) name. Alias: Column.

    .PARAMETER FormattedValue
    Specify if expected value should be provided from FormattedValues <> raw value.

    .PARAMETER RaiseErrorIfMissing
    If true, throws an exception if attribute/column is not present in row / record. Else, ignore.

    .PARAMETER Raw
    Return a plain .NET value: OptionSetValue => int, OptionSetValueCollection => int[], Money => decimal, AliasedValue => inner value, BooleanManagedProperty => bool. Lookups stay EntityReference (see AsId).

    .PARAMETER AsId
    Return the Guid of a lookup (EntityReference) column, $null when empty.

    .OUTPUTS
    System.Object. The column value.

    .EXAMPLE
    $name = Get-XrmAttributeValue -Record $entity -Name "name";

    .EXAMPLE
    $account = Get-XrmRecord -LogicalName "account" -Id $accountId -Columns "industrycode", "donotemail", "parentaccountid";
    $industryCode = $account | Get-XrmRowValue -Name "industrycode" -Raw;     # int, not the label
    $doNotEmail = $account | Get-XrmRowValue -Name "donotemail";               # bool, not "Do Not Allow"
    $parentId = $account | Get-XrmRowValue -Name "parentaccountid" -AsId;      # Guid or $null

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAttributeValue.md
#>
function Get-XrmAttributeValue {
    [CmdletBinding()]
    [OutputType([System.Object])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        [Alias("Row")]
        [Object]
        $Record,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Column")]
        [String]
        $Name,

        [Parameter(Mandatory = $false)]
        [Switch]
        $FormattedValue,

        [Parameter(Mandatory = $false)]
        [bool]
        $RaiseErrorIfMissing = $false,

        [Parameter(Mandatory = $false)]
        [Switch]
        $Raw,

        [Parameter(Mandatory = $false)]
        [Switch]
        $AsId
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        $entity = $Record;
        if ($null -ne $entity -and $entity -isnot [Microsoft.Xrm.Sdk.Entity]) {
            if ($entity.PSObject.Properties["Record"] -and $entity.Record -is [Microsoft.Xrm.Sdk.Entity]) {
                $entity = $entity.Record;
            }
            else {
                throw "Record must be an Entity or a row returned by Get-XrmRecord / Get-XrmMultipleRecords (type: $($entity.GetType().Name)).";
            }
        }

        if ($null -eq $entity -or -not $entity.Contains($Name)) {
            if ($RaiseErrorIfMissing) {
                throw "Attribute '$Name' is not in given record.";
            }
            return $null;
        }

        if ($FormattedValue -and $entity.FormattedValues.ContainsKey($Name)) {
            return $entity.FormattedValues[$Name];
        }

        $value = $entity[$Name];
        if (-not $Raw -and -not $AsId) {
            return $value;
        }

        while ($value -is [Microsoft.Xrm.Sdk.AliasedValue]) {
            $value = $value.Value;
        }

        if ($AsId) {
            if ($null -eq $value) {
                return $null;
            }
            if ($value -is [Microsoft.Xrm.Sdk.EntityReference]) {
                return $value.Id;
            }
            if ($value -is [Guid]) {
                return $value;
            }
            throw "Attribute '$Name' is not a lookup (type: $($value.GetType().Name)).";
        }

        if ($value -is [Microsoft.Xrm.Sdk.OptionSetValue]) {
            return $value.Value;
        }
        if ($value -is [Microsoft.Xrm.Sdk.OptionSetValueCollection]) {
            return , [int[]]@($value | ForEach-Object { $_.Value });
        }
        if ($value -is [Microsoft.Xrm.Sdk.Money]) {
            return $value.Value;
        }
        if ($value -is [Microsoft.Xrm.Sdk.BooleanManagedProperty]) {
            return $value.Value;
        }
        return $value;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Set-Alias GetAttributeValue Get-XrmAttributeValue;
# Module-qualified: an alias wins over a function of the same name, and its target is resolved from the caller's scope
Set-Alias Get-XrmRowValue PowerDataOps\Get-XrmAttributeValue;
Export-ModuleMember -Function Get-XrmAttributeValue -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmAttributeValue -ParameterName "Name" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $record = $null;
    if (-not ($FakeBoundParameters.ContainsKey("Record"))) {
        # TODO : Search record  for logicalname in Pipeline
        # https://gist.github.com/rohnedwards/1a78c57936d773f2a541d7ac3124f921
        return @();
    }
    else {
        $record = $FakeBoundParameters.Record;
    }
    if ($record -isnot [Microsoft.Xrm.Sdk.Entity] -and $record.Record) {
        $record = $record.Record;
    }

    $validAttributeNames = @($record.Attributes.Keys);
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}
