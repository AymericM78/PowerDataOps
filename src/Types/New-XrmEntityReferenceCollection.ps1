<#
    .SYNOPSIS
    Initialize EntityReferenceCollection object instance.

    .DESCRIPTION
    Get new EntityReferenceCollection object from entity references array.

    .PARAMETER EntityReferences
    Array of EntityReference objects to include in the collection.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReferenceCollection. The initialized EntityReferenceCollection object.

    .EXAMPLE
    $ref = New-XrmEntityReference -LogicalName "savedquery" -Id $viewId;
    $collection = New-XrmEntityReferenceCollection -EntityReferences @($ref);

    .LINK
    https://learn.microsoft.com/en-us/dotnet/api/microsoft.xrm.sdk.entityreferencecollection
#>
function New-XrmEntityReferenceCollection {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.EntityReferenceCollection")]
    param
    (
        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference[]]
        $EntityReferences
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $collection = New-Object -TypeName "Microsoft.Xrm.Sdk.EntityReferenceCollection";
        foreach ($ref in $EntityReferences) {
            $collection.Add($ref) | Out-Null;
        }

        Write-Output $collection -NoEnumerate;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmEntityReferenceCollection -Alias *;
