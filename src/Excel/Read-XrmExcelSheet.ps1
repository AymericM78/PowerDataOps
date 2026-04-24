<#
    .SYNOPSIS
    Read Excel Sheet.

    .DESCRIPTION
    Read a worksheet and return a collection of objects using the header row as property names.
    Use -AsArray to keep the legacy raw Excel array behavior.

    .PARAMETER ExcelFilePath
    Full path to Excel file.
    
    .PARAMETER SheetName
    Excel sheet name.

    .PARAMETER HeaderRowIndex
    Excel row number that contains the column headers. Default is 1.

    .PARAMETER AsArray
    Return the raw Excel value array instead of PSCustomObject rows.
#>
function Read-XrmExcelSheet {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (     
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [String]
        $ExcelFilePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SheetName,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $HeaderRowIndex = 1,

        [Parameter(Mandatory = $false)]
        [switch]
        $AsArray = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $workbook = $null;
        $sheet = $null;
        $sheetContentRange = $null;
        $excelApplication = New-Object -ComObject Excel.Application;
        try {    
            $excelApplication.Visible = $false;
            $excelApplication.ScreenUpdating = $false;
            $excelApplication.DisplayAlerts = 'False';
            $workbook = $excelApplication.Workbooks.Open($ExcelFilePath);
            
            $sheet = $workbook.Sheets | Where-Object -Property Name -EQ -Value $SheetName | Select-Object -First 1;
            if ($null -eq $sheet) {
                throw "Excel sheet '$SheetName' was not found in '$ExcelFilePath'.";
            }
            
            $sheetContentRange = $sheet.UsedRange;
            $sheetValuesArray = $sheetContentRange.Value2;

            if ($AsArray) {
                return , $sheetValuesArray;
            }

            $rowCount = [int]$sheetContentRange.Rows.Count;
            $columnCount = [int]$sheetContentRange.Columns.Count;
            if ($rowCount -lt $HeaderRowIndex) {
                throw "Excel sheet '$SheetName' does not contain header row $HeaderRowIndex.";
            }

            if ($null -eq $sheetValuesArray) {
                return @();
            }

            $headerNames = @();
            $headerNamesCount = @{};
            for ($columnIndex = 1; $columnIndex -le $columnCount; $columnIndex++) {
                if ($sheetValuesArray -is [System.Array]) {
                    $headerValue = $sheetValuesArray[$HeaderRowIndex, $columnIndex];
                }
                else {
                    $headerValue = $sheetValuesArray;
                }

                $headerName = [string]$headerValue;
                if ([string]::IsNullOrWhiteSpace($headerName)) {
                    $headerName = "Column$columnIndex";
                }

                if ($headerNamesCount.ContainsKey($headerName)) {
                    $headerNamesCount[$headerName]++;
                    $headerName = "$headerName$($headerNamesCount[$headerName])";
                }
                else {
                    $headerNamesCount[$headerName] = 1;
                }

                $headerNames += $headerName;
            }

            $rows = @();
            for ($rowIndex = ($HeaderRowIndex + 1); $rowIndex -le $rowCount; $rowIndex++) {
                $row = [ordered]@{};
                $hasValue = $false;
                for ($columnIndex = 1; $columnIndex -le $columnCount; $columnIndex++) {
                    $cellValue = $sheetValuesArray[$rowIndex, $columnIndex];
                    if ($null -ne $cellValue -and -not [string]::IsNullOrWhiteSpace([string]$cellValue)) {
                        $hasValue = $true;
                    }

                    $row[$headerNames[$columnIndex - 1]] = $cellValue;
                }

                if ($hasValue) {
                    $rows += [PSCustomObject]$row;
                }
            }

            return $rows;
        }
        finally {
            try {
                if ($null -ne $workbook) {
                    $workbook.Close();
                }
            }
            catch {
                # Ignore
            }
            try {
                $excelApplication.DisplayAlerts = 'False';
                $excelProcess = Get-Process Excel | Where-Object { $_.MainWindowHandle -eq $excelApplication.Hwnd }
                $excelApplication.Quit();

                if ($null -ne $sheetContentRange) {
                    [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheetContentRange);
                }
                if ($null -ne $sheet) {
                    [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet);
                }
                if ($null -ne $workbook) {
                    [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook);
                }
                [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($excelApplication);
                [GC]::Collect();
                [GC]::WaitForPendingFinalizers();
                
                if ($null -ne $excelProcess) {
                    Stop-Process -Id $excelProcess.Id;
                }
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