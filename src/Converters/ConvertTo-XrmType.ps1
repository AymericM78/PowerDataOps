<#
    .SYNOPSIS
    Convert a value to the appropriate Dataverse SDK type.

    .DESCRIPTION
    Transform a raw value (string, number) to a typed Dataverse attribute value based on the specified type
    (int, decimal, datetime, money, bool, guid, optionset, optionsetvalues, entityreference, string).
    Strings are parsed with the current culture unless Culture is given; values that are already numbers or dates are cast, not parsed.
    A bool is read from a bool, a number (0 = false) or a string matched against TrueValues / FalseValues; any other string raises an error.

    .PARAMETER Type
    Target Dataverse attribute type name.

    .PARAMETER Value
    Raw value to convert.

    .PARAMETER EntityLogicalName
    Logical name of the target entity (required for entityreference type).

    .PARAMETER Culture
    Culture used to parse int, decimal, money and datetime strings, e.g. "fr-FR" or [cultureinfo]::InvariantCulture. (Default: current culture)

    .PARAMETER Format
    Exact format of a datetime string (e.g. "dd/MM/yyyy"), parsed with DateTime.ParseExact. (Default: none, DateTime.Parse is used)

    .PARAMETER TrueValues
    Strings read as true for the bool type, case-insensitive. (Default: "true", "1", "yes")

    .PARAMETER FalseValues
    Strings read as false for the bool type, case-insensitive. An empty string is always false. (Default: "false", "0", "no")

    .OUTPUTS
    System.Object. The typed value (int, decimal, DateTime, Money, bool, Guid, OptionSetValue, OptionSetValueCollection, EntityReference or string).

    .EXAMPLE
    $moneyValue = ConvertTo-XrmType -Type "money" -Value "150.50" -Culture ([cultureinfo]::InvariantCulture);

    .EXAMPLE
    $optionSet = ConvertTo-XrmType -Type "optionset" -Value 1;

    .EXAMPLE
    $ref = ConvertTo-XrmType -Type "entityreference" -Value $guid -EntityLogicalName "account";

    .EXAMPLE
    $date = ConvertTo-XrmType -Type "datetime" -Value "31/12/2026" -Format "dd/MM/yyyy";

    .EXAMPLE
    $flag = ConvertTo-XrmType -Type "bool" -Value "Oui" -TrueValues "oui" -FalseValues "non";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/ConvertTo-XrmType.md
#>
function ConvertTo-XrmType {
    [CmdletBinding()]
    [OutputType([System.Object])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("int", "decimal", "datetime", "money", "bool", "guid", "optionset", "optionsetvalues", "entityreference", "string")]
        [string]
        $Type,

        [Parameter(Mandatory = $true)]
        $Value,

        [Parameter(Mandatory = $false)]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [System.Globalization.CultureInfo]
        $Culture = [System.Globalization.CultureInfo]::CurrentCulture,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Format,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $TrueValues = @("true", "1", "yes"),

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $FalseValues = @("false", "0", "no")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $result = $null;
        switch ($Type) {
            "int" {
                $result = if ($Value -is [string]) { [int]::Parse($Value, $Culture) } else { [int]$Value };
                break;
            }
            "decimal" {
                $result = if ($Value -is [string]) { [decimal]::Parse($Value, $Culture) } else { [decimal]$Value };
                break;
            }
            "datetime" {
                if ($Value -is [datetime]) {
                    $result = $Value;
                }
                elseif ($PSBoundParameters.ContainsKey('Format')) {
                    $result = [datetime]::ParseExact($Value, $Format, $Culture);
                }
                else {
                    $result = [datetime]::Parse($Value, $Culture);
                }
                break;
            }
            "money" {
                $decimalValue = if ($Value -is [string]) { [decimal]::Parse($Value, $Culture) } else { [decimal]$Value };
                $result = New-XrmMoney -Value $decimalValue;
                break;
            }
            "bool" {
                if ($Value -is [string]) {
                    $text = $Value.Trim();
                    if ($text -eq "" -or $FalseValues -contains $text) {
                        $result = $false;
                    }
                    elseif ($TrueValues -contains $text) {
                        $result = $true;
                    }
                    else {
                        throw "Cannot convert '$Value' to bool. Accepted values: $($TrueValues -join ', ') (true); $($FalseValues -join ', ') (false).";
                    }
                }
                else {
                    $result = [bool]$Value;
                }
                break;
            }
            "guid" {
                $result = [Guid]::Parse($Value);
                break;
            }
            "optionset" {
                $result = New-XrmOptionSetValue -Value ([int]$Value);
                break;
            }
            "optionsetvalues" {
                $intValues = @();
                if ($Value -is [array]) {
                    $intValues = $Value | ForEach-Object { [int]$_ };
                }
                else {
                    $intValues = @([int]$Value);
                };
                $result = New-XrmOptionSetValues -Values $intValues;
                break;
            }
            "entityreference" {
                if (-not $EntityLogicalName) {
                    throw "EntityLogicalName is required for entityreference type.";
                };
                $result = New-XrmEntityReference -LogicalName $EntityLogicalName -Id ([Guid]::Parse($Value));
                break;
            }
            "string" {
                $result = [string]$Value;
                break;
            }
        };
        $result;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function ConvertTo-XrmType -Alias *;
