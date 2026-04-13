<#
    .SYNOPSIS
    Add columns to a link entity.

    .DESCRIPTION
    Add one or more columns to a given link entity for retrieval.

    .PARAMETER Link
    LinkEntity where columns should be added.

    .PARAMETER Columns
    Array of column / attribute logical names to add.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Query.LinkEntity. The updated LinkEntity for pipeline chaining.

    .EXAMPLE
    $link = $query | Add-XrmQueryLink -ToEntityName "contact" -FromAttributeName "contactid" -ToAttributeName "contactid";
    $link | Add-XrmQueryLinkColumns -Columns @("fullname", "emailaddress1");
#>
function Add-XrmQueryLinkColumns {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.Query.LinkEntity")]
    param
    (        
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.Query.LinkEntity]
        $Link,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        foreach ($column in $Columns) {
            $Link.Columns.AddColumn($column);
        }
        $Link;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmQueryLinkColumns -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmQueryLinkColumns -ParameterName "Columns" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    if (-not ($fakeBoundParameters.ContainsKey("Link"))) {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.Link.LinkToEntityName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}
