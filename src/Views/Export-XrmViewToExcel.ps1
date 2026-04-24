<#
    .SYNOPSIS
    Export a Dataverse view to an Excel file.

    .DESCRIPTION
    Execute the ExportToExcel action for a Dataverse saved query and save the generated workbook locally.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ViewReference
    EntityReference of the Dataverse view to export. Supported logical names are savedquery and userquery.

    .PARAMETER EntityLogicalName
    Logical name of the Dataverse entity used to search the view by name.

    .PARAMETER ViewName
    Display name of the Dataverse view to export.

    .PARAMETER OutputPath
    Full path where the generated Excel workbook will be written.

    .OUTPUTS
    System.String. The full path of the exported Excel file.

    .EXAMPLE
    Export-XrmViewToExcel -EntityLogicalName "account" -ViewName "Active Accounts" -OutputPath "C:\Temp\Accounts.xlsx";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
#>
function Export-XrmViewToExcel {
    [CmdletBinding(DefaultParameterSetName = 'ByReference')]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $ViewReference,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityLogicalName,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ViewName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $OutputPath
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
            if (-not [string]::IsNullOrWhiteSpace($ViewReference.LogicalName) -and @('savedquery', 'userquery') -notcontains $ViewReference.LogicalName) {
                throw "ViewReference logical name must be 'savedquery' or 'userquery'.";
            }
        }
        else {
            $selectedViews = $XrmClient | Get-XrmViews -EntityLogicalName $EntityLogicalName -Columns 'name' | Where-Object -Property name -EQ -Value $ViewName;
            if ($null -eq $selectedViews -or @($selectedViews).Count -eq 0) {
                throw "View '$ViewName' was not found for entity '$EntityLogicalName'.";
            }
            if (@($selectedViews).Count -gt 1) {
                throw "Multiple views named '$ViewName' were found for entity '$EntityLogicalName'. Use -ViewReference instead.";
            }

            $ViewReference = @($selectedViews)[0].Reference;
        }

        $request = New-XrmRequest -Name 'ExportToExcel';
        $request | Add-XrmRequestParameter -Name 'View' -Value $ViewReference | Out-Null;
        $request | Add-XrmRequestParameter -Name 'FetchXml' -Value '' | Out-Null;
        $request | Add-XrmRequestParameter -Name 'LayoutXml' -Value '' | Out-Null;
        $request | Add-XrmRequestParameter -Name 'QueryApi' -Value '' | Out-Null;
        $request | Add-XrmRequestParameter -Name 'QueryParameters' -Value ([Microsoft.Crm.Sdk.Messages.InputArgumentCollection](New-Object -TypeName 'Microsoft.Crm.Sdk.Messages.InputArgumentCollection')) | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $excelFile = $response.Results['ExcelFile'];
        if ($null -eq $excelFile) {
            throw 'ExportToExcel did not return any workbook content.';
        }

        Initialize-XrmPath -Path $OutputPath -AsFilePath | Out-Null;
        [System.IO.File]::WriteAllBytes($OutputPath, $excelFile);

        $OutputPath;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Export-XrmViewToExcel -Alias *;