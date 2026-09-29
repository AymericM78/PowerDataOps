<#
    .SYNOPSIS
    Resolve a lookup from column values.

    .DESCRIPTION
    Find the one row of LogicalName whose columns match Attributes (AND) and return its EntityReference, e.g. to fill a lookup during a data import.
    No match raises an error (or returns $null with IfExists); several matches always raise an error.
    With Cache, the resolutions (misses included) are stored in the caller's hashtable and reused: pass the same hashtable to every call of an import.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalName
    Table / Entity logical name of the row to find.

    .PARAMETER Attributes
    Hashtable of column = value conditions, all required. A $null value matches an empty column; an EntityReference, OptionSetValue or Money value is compared on its id or value.

    .PARAMETER Cache
    Hashtable owned by the caller, used to store and reuse resolutions. (Default: no cache)

    .PARAMETER IfExists
    Return $null when no row matches, instead of raising an error.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference of the matching row.

    .EXAMPLE
    $accountRef = Resolve-XrmEntityReference -XrmClient $xrmClient -LogicalName "account" -Attributes @{ accountnumber = "A-0042" };

    .EXAMPLE
    $cache = @{};
    foreach ($line in $csvLines) {
        $contact = New-XrmEntity -LogicalName "contact" -Attributes @{
            lastname         = $line.LastName;
            parentcustomerid = (Resolve-XrmEntityReference -XrmClient $xrmClient -LogicalName "account" -Attributes @{ accountnumber = $line.AccountNumber } -Cache $cache -IfExists);
        };
        $xrmClient | Add-XrmRecord -Record $contact | Out-Null;
    }

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Resolve-XrmEntityReference.md
#>
function Resolve-XrmEntityReference {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Attributes,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Hashtable]
        $Cache,

        [Parameter(Mandatory = $false)]
        [switch]
        $IfExists
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $criteria = ($Attributes.Keys | Sort-Object | ForEach-Object {
                $criterionValue = $Attributes[$_];
                if ($criterionValue -is [Microsoft.Xrm.Sdk.EntityReference]) { $criterionValue = $criterionValue.Id; }
                elseif ($criterionValue -is [Microsoft.Xrm.Sdk.OptionSetValue] -or $criterionValue -is [Microsoft.Xrm.Sdk.Money]) { $criterionValue = $criterionValue.Value; }
                # Dataverse compares strings without case: so does the cache key
                "$($_.ToLowerInvariant())=$("$criterionValue".ToLowerInvariant())";
            }) -join "|";
        $cacheKey = "$($LogicalName.ToLowerInvariant())|$criteria";

        $reference = $null;
        if ($PSBoundParameters.ContainsKey('Cache') -and $Cache.ContainsKey($cacheKey)) {
            $reference = $Cache[$cacheKey];
        }
        else {
            $row = $XrmClient | Get-XrmRecord -LogicalName $LogicalName -Attributes $Attributes -Unique -AsEntity;
            if ($row) {
                $reference = New-XrmEntityReference -LogicalName $LogicalName -Id $row.Id;
            }
            if ($PSBoundParameters.ContainsKey('Cache')) {
                $Cache[$cacheKey] = $reference;
            }
        }

        if ($null -eq $reference -and -not $IfExists) {
            throw "No '$LogicalName' row matches $($criteria.Replace('|', ', ')).";
        }
        $reference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Resolve-XrmEntityReference -Alias *;

Register-ArgumentCompleter -CommandName Resolve-XrmEntityReference -ParameterName "LogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
