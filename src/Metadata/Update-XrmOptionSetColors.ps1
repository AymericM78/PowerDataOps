<#
    .SYNOPSIS
    Update option set value colors.

    .DESCRIPTION
    Update the color property of option set values for a given picklist attribute using the UpdateOptionValue SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical name of the entity that contains the attribute.

    .PARAMETER AttributeLogicalName
    Logical name of the picklist attribute.

    .PARAMETER Colors
    Hashtable mapping option set integer values to hex color strings (e.g., @{ 1 = "#FF0000"; 2 = "#00FF00" }).

    .PARAMETER PublishChanges
    Whether to publish customizations after updating. (Default: true)

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $colors = @{ 100000000 = "#FF5733"; 100000001 = "#33FF57"; 100000002 = "#3357FF" };
    Update-XrmOptionSetColors -XrmClient $xrmClient -EntityLogicalName "account" -AttributeLogicalName "statuscode" -Colors $colors;
#>
function Update-XrmOptionSetColors {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $AttributeLogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [hashtable]
        $Colors,

        [Parameter(Mandatory = $false)]
        [bool]
        $PublishChanges = $true
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        foreach ($optionValue in $Colors.Keys) {
            $color = $Colors[$optionValue];

            $request = New-XrmRequest -Name "UpdateOptionValue";
            $request | Add-XrmRequestParameter -Name "EntityLogicalName" -Value $EntityLogicalName | Out-Null;
            $request | Add-XrmRequestParameter -Name "AttributeLogicalName" -Value $AttributeLogicalName | Out-Null;
            $request | Add-XrmRequestParameter -Name "Value" -Value ([int]$optionValue) | Out-Null;
            $request | Add-XrmRequestParameter -Name "Color" -Value $color | Out-Null;
            Invoke-XrmRequest -XrmClient $XrmClient -Request $request | Out-Null;
        };

        if ($PublishChanges) {
            $publishRequest = New-XrmRequest -Name "PublishXml";
            $publishXml = "<importexportxml><entities><entity>$EntityLogicalName</entity></entities></importexportxml>";
            $publishRequest | Add-XrmRequestParameter -Name "ParameterXml" -Value $publishXml | Out-Null;
            Invoke-XrmRequest -XrmClient $XrmClient -Request $publishRequest | Out-Null;
        };
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Update-XrmOptionSetColors -Alias *;
