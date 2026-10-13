<#
    .SYNOPSIS
    Split given collection into specified sized collections.

    .Description
    Extract chunk collections from given one.
    The collection is given with -Collection or through the pipeline (one element at a time): the chunks are written once every element is read.
    Each chunk is written as one array, the last one may be smaller, and a collection smaller than Count gives one chunk. Pipe the result (| ForEach-Object) or collect it with @() to get the list of chunks.

    .PARAMETER Collection
    Input array to split, or one element when piped.

    .PARAMETER Count
    Target collections size.

    .OUTPUTS
    System.Object[]. One array per chunk.

    .EXAMPLE
    $chunks = @(Split-XrmCollection -Collection $requests -Count 1000);
    foreach ($chunk in $chunks) { Invoke-XrmBulkRequests -Requests $chunk; }

    .EXAMPLE
    $requests | Split-XrmCollection -Count 1000 | ForEach-Object { Invoke-XrmBulkRequests -Requests $_; }

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Split-XrmCollection.md
#>
function Split-XrmCollection {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        $Collection,

        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $Count
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
        $items = [System.Collections.Generic.List[object]]::new();
    }
    process {
        # From the pipeline, each call brings one element (which may itself be an array): it is kept whole
        if ($MyInvocation.ExpectingInput) {
            $items.Add($Collection);
        }
        elseif ($null -ne $Collection) {
            foreach ($item in $Collection) {
                $items.Add($item);
            }
        }
    }
    end {
        for ($index = 0; $index -lt $items.Count; $index += $Count) {
            , $items.GetRange($index, [Math]::Min($Count, $items.Count - $index)).ToArray();
        }
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Split-XrmCollection -Alias *;
