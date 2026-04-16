<#
    .SYNOPSIS
    Download a file from a file or image column.

    .DESCRIPTION
    Download a file stored in a Dataverse file/image column using the InitializeFileBlocksDownload and DownloadBlock SDK messages.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RecordReference
    EntityReference of the record containing the file column.

    .PARAMETER FileAttributeName
    Logical name of the file or image column.

    .PARAMETER OutputPath
    Full file path where the downloaded file will be saved. Optional. If not provided, saves to temp folder with original filename.

    .OUTPUTS
    System.String. The full path of the downloaded file.

    .EXAMPLE
    $filePath = Get-XrmRecordFileDownload -RecordReference $recordRef -FileAttributeName "new_document";
    $filePath = Get-XrmRecordFileDownload -RecordReference $recordRef -FileAttributeName "entityimage" -OutputPath "C:\Temp\photo.png";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/file-attributes
#>
function Get-XrmRecordFileDownload {
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RecordReference,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $FileAttributeName,

        [Parameter(Mandatory = $false)]
        [string]
        $OutputPath
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        # Initialize download
        $initRequest = New-XrmRequest -Name "InitializeFileBlocksDownload";
        $target = New-XrmEntityReference -LogicalName $RecordReference.LogicalName -Id $RecordReference.Id;
        $initRequest | Add-XrmRequestParameter -Name "Target" -Value $target | Out-Null;
        $initRequest | Add-XrmRequestParameter -Name "FileAttributeName" -Value $FileAttributeName | Out-Null;

        $initResponse = $XrmClient | Invoke-XrmRequest -Request $initRequest;
        $fileContinuationToken = $initResponse.Results["FileContinuationToken"];
        $fileName = $initResponse.Results["FileName"];
        $fileSizeInBytes = $initResponse.Results["FileSizeInBytes"];

        if (-not $PSBoundParameters.ContainsKey('OutputPath')) {
            $OutputPath = Join-Path $env:TEMP $fileName;
        }

        # Download blocks
        $fileStream = [System.IO.File]::Create($OutputPath);
        try {
            $offset = 0;
            $blockSize = 4 * 1024 * 1024; # 4 MB blocks

            while ($offset -lt $fileSizeInBytes) {
                $downloadRequest = New-XrmRequest -Name "DownloadBlock";
                $downloadRequest | Add-XrmRequestParameter -Name "FileContinuationToken" -Value $fileContinuationToken | Out-Null;
                $downloadRequest | Add-XrmRequestParameter -Name "BlockLength" -Value $blockSize | Out-Null;
                $downloadRequest | Add-XrmRequestParameter -Name "Offset" -Value $offset | Out-Null;

                $downloadResponse = $XrmClient | Invoke-XrmRequest -Request $downloadRequest;
                $data = $downloadResponse.Results["Data"];

                $fileStream.Write($data, 0, $data.Length);
                $offset += $data.Length;
            }
        }
        finally {
            $fileStream.Close();
            $fileStream.Dispose();
        }

        $OutputPath;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmRecordFileDownload -Alias *;
