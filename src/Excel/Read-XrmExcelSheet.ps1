<#
    .SYNOPSIS
    Read Excel Sheet.
#>
function Read-XrmExcelSheet {
    [CmdletBinding()]
    param
    (     
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ExcelFilePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SheetName
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
                    
        $excelApplication = New-Object -ComObject Excel.Application;
        try {    
            $excelApplication.Visible = $false;
            $excelApplication.ScreenUpdating = $false;
            $excelApplication.DisplayAlerts = 'False';
            $workbook = $excelApplication.Workbooks.Open($ExcelFilePath);
            
            $sheet = $workbook.Sheets | Where-Object -Property Name -EQ -Value $SheetName;
            
            $sheetContentRange = $sheet.UsedRange;
            $sheetValuesArray = $sheetContentRange.Value([System.Type]::Missing);

            return , $sheetValuesArray;
        }
        finally {
            try {
                $workbook.Close();
            }
            catch {
                # Ignore
            }
            try {
                $excelApplication.DisplayAlerts = 'False';
                $excelProcess = Get-Process Excel | Where-Object { $_.MainWindowHandle -eq $excelApplication.Hwnd }
                $excelApplication.Quit();

                [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheetContentRange);
                [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet);
                [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook);
                [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($excelApplication);
                [GC]::Collect();
                [GC]::WaitForPendingFinalizers();
                
                Stop-Process -Id $excelProcess.Id;
            }
            catch {
                # Ignore
            }
        }                
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Read-XrmExcelSheet -Alias *;