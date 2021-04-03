<#
    .SYNOPSIS
    Upload a file to an entity record's file attribute field in Microsoft Dataverse.

    .Description
    Upload a file to a date row's (entity record's) file field from Microsoft Dataverse table.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER Record
    Record (row) to update.

    .PARAMETER FileAttributeLogicalName
    Entity file attribute name.

    .PARAMETER FilePath
    Path to file on the OS file system.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    # Create a new record that has a File attribute with the logical name: new_document
    $entityRecord = New-XrmEntity -LogicalName "new_DocumentStore" -Attributes @{
        "name" = "file1";
    }
    $entityRecord.Id = Add-XrmRecord -Record $entityRecord
    Update-XrmRecordFileUpload -XrmClient $XrmClient -Record $entityRecord -FileAttributeLogicalName "new_document" -FilePath 'C:\temp\test.docx'
#>
function Update-XrmRecordFileUpload
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.Entity]
        $Record,        

        [Parameter(Mandatory = $true)]
        [String]
        $FileAttributeLogicalName,

        [Parameter(Mandatory = $true)]
        [String]
        $FilePath
    )

    process 
    {
        # Created based on C# code exmaple from: https://gist.github.com/huseyinzengin91/8cbaa0ae3d11d985676560bbf470564f

        # File upload block size is limitted to 4MB
        $blockSizeByteLimit = 4194304
        $contentType = "application/octet-stream"

        $entityLogicalName = $Record.ToEntityReference().LogicalName
        [Guid]$recordId = $Record.ToEntityReference().Id

        # Get the filename from the filePath
        $fileName = [System.IO.Path]::GetFileName($FilePath)
        
        # # Lookup file's content type
        # # As of 2021-04-02 setting the content type to a value other than "application/octet-stream", doesn't change the content-type returned when downloading the file.
        # $fileExtension = [System.IO.Path]::GetExtension($FilePath)
        # Add-Type -AssemblyName "System.Web"
        # $contentType = [System.Web.MimeMapping]::GetMimeMapping($FilePath)

        # get the file size and calcualte the number of required parts
        $fileInfo = New-Object System.IO.FileInfo($FilePath)
        $totalFileBlocks = [int]($fileInfo.Length / $blockSizeByteLimit) + 1

        #Read the file and one chunk at a time
        $fileReader = [System.IO.File]::OpenRead($FilePath)
        $fileBlockCounter = 0
        $fileBuffer = New-Object Byte[] $blockSizeByteLimit
        $fileHasMoreData = $true

        # Keep an array of Block IDs to pass as part of the commit.
        $blockIds = [System.Collections.Generic.List[String]]::new()

        # Init file blocks upload request
        $initFileBlocksUploadRequest = [Microsoft.Crm.Sdk.Messages.InitializeFileBlocksUploadRequest]::new()
        $initFileBlocksUploadRequest.FileAttributeName = $FileAttributeLogicalName
        $initFileBlocksUploadRequest.FileName = $fileName
        $initFileBlocksUploadRequest.Target = $Record.ToEntityReference()

        $initResponse = $XrmClient.Execute($initFileBlocksUploadRequest)
        $fileContinuationToken = $initResponse.FileContinuationToken

        # Read file blocks until there is no more data
        while ($fileHasMoreData) 
        {
            # read a chuck of data form the file
            $fileBytesRead = $fileReader.Read($fileBuffer, 0, $fileBuffer.Length)
            $fileDataBlock = $fileBuffer

            # check if we read less than a full block of data from the file
            if($fileBytesRead -ne $fileBuffer.Length)
            {
                # If yes, then there is no more file data to read
                $fileHasMoreData = $false
                # truncate the output arrat to the number of bytes read
                $fileDataBlock = New-Object Byte[] $fileBytesRead
                [System.Array]::Copy($fileBuffer, $fileDataBlock, $fileBytesRead)
            }

            # Save the file block to the Dataverse entitie's file attribute

            # Generate a new random blockId and add it to the list of blockIds
            $blockId = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([System.Guid]::NewGuid().ToString()))
            $blockIds.Add($blockId)

            $uploadBlockRequest = [Microsoft.Crm.Sdk.Messages.UploadBlockRequest]@{
                FileContinuationToken = $fileContinuationToken
                BlockId = $blockId
                BlockData = $fileDataBlock
            }

            # Upload a block
            $uploadBlockResponse = [Microsoft.Crm.Sdk.Messages.UploadBlockResponse]$XRMClient.Execute($uploadBlockRequest)

            $fileBlockCounter = $fileBlockCounter + 1
        }
        # Finished reading from the file. Close the reader
        $fileReader.Close()

        # Commit all file blocks
        $commitBlocksUploadRequest = [Microsoft.Crm.Sdk.Messages.CommitFileBlocksUploadRequest]@{
            BlockList = $blockIds.ToArray()
            FileContinuationToken = $fileContinuationToken
            FileName = $fileName
            MimeType = $contentType
        }
        $commitBlocksUploadResponse = [Microsoft.Crm.Sdk.Messages.CommitFileBlocksUploadResponse]$XrmClient.Execute($commitBlocksUploadRequest)

        #Write-Output "Xrm File upload complete. File name: $fileName, File size: $($fileInfo.Length), Blocks uploaded: $fileBlockCounter, FileId: $($commitBlocksUploadResponse.FileId)"
    }
}

Export-ModuleMember -Function Update-XrmRecordFileUpload -Alias *;