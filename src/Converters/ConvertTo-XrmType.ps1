<#
    .SYNOPSIS
    Convert a value to the appropriate Dataverse SDK type.

    .DESCRIPTION
    Transform a raw value (string, number) to a typed Dataverse attribute value based on the specified type
    (int, decimal, datetime, money, bool, guid, optionset, optionsetvalues, entityreference, string).

    .PARAMETER Type
    Target Dataverse attribute type name.

    .PARAMETER Value
    Raw value to convert.

    .PARAMETER EntityLogicalName
    Logical name of the target entity (required for entityreference type).

    .EXAMPLE
    $moneyValue = ConvertTo-XrmType -Type "money" -Value "150.50";

    .EXAMPLE
    $optionSet = ConvertTo-XrmType -Type "optionset" -Value 1;

    .EXAMPLE
    $ref = ConvertTo-XrmType -Type "entityreference" -Value $guid -EntityLogicalName "account";
#>
function ConvertTo-XrmType {
    [CmdletBinding()]
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
        $EntityLogicalName
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $result = $null;
        switch ($Type) {
            "int" {
                $result = [int]::Parse($Value);
                break;
            }
            "decimal" {
                $result = [decimal]::Parse($Value);
                break;
            }
            "datetime" {
                $result = [datetime]::Parse($Value);
                break;
            }
            "money" {
                $decimalValue = [decimal]::Parse($Value);
                $result = New-XrmMoney -Value $decimalValue;
                break;
            }
            "bool" {
                $result = [bool]$Value;
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
