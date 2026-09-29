<#
    .SYNOPSIS
    Initialize EntityCollection object instance.

    .DESCRIPTION
    Get new Entity Collection object from entities array.
    The collection is built with its constructor, so it carries no PowerShell PSObject adapter and can be stored as is in an attribute or a request parameter.

    .PARAMETER Entities
    Entities array. (Default: empty collection)

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityCollection. The initialized EntityCollection object.

    .EXAMPLE
    $collection = New-XrmEntityCollection -Entities @($entity1, $entity2);

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmEntityCollection.md
#>
function New-XrmEntityCollection {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityCollection])]
    param
    (
        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [Microsoft.Xrm.Sdk.Entity[]]
        $Entities = @()
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        $entityCollection = [Microsoft.Xrm.Sdk.EntityCollection]::new();
        foreach ($entity in $Entities) {
            $entityCollection.Entities.Add($entity);
        }

        return ,$entityCollection;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmEntityCollection -Alias *;
