<#
    .SYNOPSIS
    Add Solution Components
#>
function Add-XrmSolutionComponent {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $ComponentId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]
        $ComponentType,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]        
        [bool]
        $DoNotIncludeSubcomponents = $true,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]
        $AddRequiredComponents = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $addComponentRequest = New-XrmRequest -Name "AddSolutionComponent";
        $addComponentRequest = $addComponentRequest | Add-XrmRequestParameter -Name "SolutionUniqueName" -Value $SolutionUniqueName;
        $addComponentRequest = $addComponentRequest | Add-XrmRequestParameter -Name "ComponentId" -Value $ComponentId;
        $addComponentRequest = $addComponentRequest | Add-XrmRequestParameter -Name "ComponentType" -Value $ComponentType;
        $addComponentRequest = $addComponentRequest | Add-XrmRequestParameter -Name "AddRequiredComponents" -Value $AddRequiredComponents;
        if (-not $DoNotIncludeSubcomponents) {
            $addComponentRequest = $addComponentRequest | Add-XrmRequestParameter -Name "DoNotIncludeSubcomponents" -Value $DoNotIncludeSubcomponents;
        }

        $response = $XrmClient | Invoke-XrmRequest -Request $addComponentRequest;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmSolutionComponent -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmSolutionComponent -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}