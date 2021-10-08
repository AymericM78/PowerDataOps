<#
    .SYNOPSIS
    Add link entity to given query expression.

    .DESCRIPTION
    Add new link to given query expression to join to another table / entity.

    .PARAMETER Query
    QueryExpression where condition should be add.

    .PARAMETER FromAttributeName
    Gets or sets the logical name of the attribute of the entity that you are linking from.

    .PARAMETER ToEntityName
    Gets or sets the logical name of the entity that you are linking to.

    .PARAMETER ToAttributeName
    Gets or sets the logical name of the attribute of the entity that you are linking to.
#>
function Add-XrmQueryLink {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.Query.LinkEntity")]
    param
    (        
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.Query.QueryExpression]
        $Query,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FromAttributeName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ToEntityName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ToAttributeName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Alias,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Query.JoinOperator]
        $JoinOperator =  [Microsoft.Xrm.Sdk.Query.JoinOperator]::Inner
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {

        $link = $Query.AddLink($ToEntityName, $FromAttributeName, $ToAttributeName, $JoinOperator);
        if ($PSBoundParameters.ContainsKey('Alias')) {
            $link.EntityAlias = $Alias;
        }
        $link;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmQueryLink -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmQueryLink -ParameterName "FromAttributeName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    # TODO : Search query in pipeline
    if (-not ($fakeBoundParameters.ContainsKey("Query"))) {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.Query.EntityName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}

Register-ArgumentCompleter -CommandName Add-XrmQueryLink -ParameterName "ToEntityName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

Register-ArgumentCompleter -CommandName Add-XrmQueryLink -ParameterName "ToAttributeName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    # TODO : Search query in pipeline
    if (-not ($fakeBoundParameters.ContainsKey("ToEntityName"))) {
        return @();
    }

    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $fakeBoundParameters.ToEntityName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}