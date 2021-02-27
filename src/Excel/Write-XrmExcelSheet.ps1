<#
    .SYNOPSIS
    Write Excel Sheet.
#>
function Write-XrmExcelSheet {
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
        $SheetName,

        [Parameter(Mandatory = $true)]
        [PsObject[]]
        $Records,

        [Parameter(Mandatory = $true)]
        [System.Collections.Specialized.OrderedDictionary]
        $HeaderMappings,

        [Parameter(Mandatory = $false)]
        [int[]]
        $ColumnsSize = @(),

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TableStyle = "TableStyleMedium15"
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
            $workbook = $excelApplication.Workbooks.Add();    
            
            Write-HostAndLog "Adding Excel Sheet '$SheetName' ..." -ForegroundColor Gray;
            $sheet = $workbook.Sheets.Add();
            if ($SheetName.Length -gt 30) {
                $SheetName = $SheetName.Remove(31);
            }
            $sheet.Name = $SheetName;
            Write-HostAndLog "Adding Excel Sheet '$SheetName' done!" -ForegroundColor Green;
        
            $rowCount = $Records.Count + 1;
            $columnCount = $HeaderMappings.Count;
        
            $excelData = [string[, ]]::new($rowCount, $columnCount);
            $rowNumber = 0;
            $columnNumber = 0;
            foreach ($headerMappingKey in $HeaderMappings.Keys) {
                $excelData[$rowNumber, $columnNumber] = $HeaderMappings[$headerMappingKey];
                $columnNumber++;
            }
            
            $current = 0;
            $total = $Records.Count;
            foreach ($object in $Records) {
                $current++;
                $percent = ($current / $total) * 100;
        
                Write-Progress -Activity "Provisioning Excel data" -Status "Processing record ...[$current/$total]" -PercentComplete $percent;
        
                $rowNumber ++;
                $columnNumber = 0;

                $record = $object.Record;
        
                foreach ($headerMappingKey in $HeaderMappings.Keys) {
                    if ($record.FormattedValues.ContainsKey($headerMappingKey)) {
                        $value = $record.FormattedValues[$headerMappingKey];
                    }
                    else {
                        $value = $record[$headerMappingKey];
                    }
        
                    $excelData[$rowNumber, $columnNumber] = $value;
                    $columnNumber++;
                }
            }
            Write-Progress -Activity "Provisioning Excel data" -Completed;
        
            # Push data to Excel
            Write-HostAndLog "Writing data to Excel ..." -ForegroundColor Gray;
            $startCell = $sheet.Cells[1, 1];
            $endCell = $sheet.Cells[($rowCount), $columnCount];
            $sheetContentRange = $sheet.Range($startCell, $endCell);
            $sheetContentRange.Value2 = $excelData;
            Write-HostAndLog "Writing data to Excel done!" -ForegroundColor Green;
            
            # Apply table format
            Write-HostAndLog "Formatting Excel table ..." -ForegroundColor Gray;
            $tableName = "Table$SheetName";
            $sheetContentRange.Worksheet.ListObjects.Add([Microsoft.Office.Interop.Excel.XlListObjectSourceType]::xlSrcRange, $sheetContentRange, [System.Type]::Missing, [Microsoft.Office.Interop.Excel.XlYesNoGuess]::xlYes, [System.Type]::Missing).Name = $tableName;
            $sheetContentRange.Select() | Out-Null;
            $sheetContentRange.Worksheet.ListObjects[$tableName].TableStyle = $tableStyle;  
            Write-HostAndLog "Formatting Excel table done!" -ForegroundColor Green;
        
            # Resize columns
            if ($ColumnsSize.Length -gt 0) {
                Write-HostAndLog "Resizing columns ..." -ForegroundColor Gray;
                for ($i = 0; $i -lt $ColumnsSize.Count; $i++) {
                    $columnIndex = $i + 1;
                    if ($full) {
                        $columnIndex ++;
                    }
                    $sheet.Columns($columnIndex).ColumnWidth = $ColumnsSize[$i];
                }
                Write-HostAndLog "Resizing columns done!" -ForegroundColor Green;
            }
        
            Write-HostAndLog "Saving Excel file to '$ExcelFilePath' ..." -ForegroundColor Gray;
            if (Test-Path -Path $ExcelFilePath) {
                Remove-Item -Path $ExcelFilePath -Force;
            }
            $workbook.SaveAs($ExcelFilePath);
            $workbook.Close();
            Write-HostAndLog "Saving Excel file to '$ExcelFilePath' done!" -ForegroundColor Green;
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

Export-ModuleMember -Function Write-XrmExcelSheet -Alias *;