<#
    .SYNOPSIS
    Split given collection into specified sized collections.

    .Description
    Extract chunk collections from given one.

    .PARAMETER Collection
    Input array to split.

    .PARAMETER Count
    Target collections size.
#>
function Split-XrmCollection {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
        $Collection,
        [Parameter(Mandatory = $true)]
        [int] 
        $Count
    )
    begin {
        $Index = 0
        $Array = @()
        $TempArray = @()
    }
    process {

        if(-not $Collection){
            return @();
        }

        if($Collection.Count -lt $Count){
            return $Collection;
        }

        foreach ($item in $Collection) {
            if (++$Index -eq $Count) {
                $Index = 0;
                $Array += , @($TempArray + $item);
                $TempArray = @();
                continue;
            }
            $TempArray += $item;
        }
    }
    end {
        if ($TempArray) { 
            $Array += , $TempArray;
        }
        $Array;
    }
}
Export-ModuleMember -Function Split-XrmCollection -Alias *;