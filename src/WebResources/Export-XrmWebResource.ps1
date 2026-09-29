<#
    .SYNOPSIS
    Save the content of a web resource to a file.

    .DESCRIPTION
    Read a web resource by Id or by name, decode its content and write it under OutputPath.
    The file path follows the web resource name, "/" becoming folders (new_/scripts/app.js => OutputPath\new_\scripts\app.js), so that Sync-XrmWebResources can send the folder back.
    Raises an error when the web resource does not exist.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Id
    Web resource unique identifier.

    .PARAMETER Name
    Web resource name (e.g. "new_/scripts/app.js").

    .PARAMETER OutputPath
    Root folder of the file. Created when missing.

    .OUTPUTS
    System.String. Path of the written file.

    .EXAMPLE
    $path = Export-XrmWebResource -XrmClient $xrmClient -Name "new_/scripts/app.js" -OutputPath "C:\Temp\webresources";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmWebResource.md
#>
function Export-XrmWebResource {
    [CmdletBinding(DefaultParameterSetName = "Name")]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ParameterSetName = "Id")]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $Id,

        [Parameter(Mandatory = $true, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

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
        if ($PSCmdlet.ParameterSetName -eq "Id") {
            $webResource = $XrmClient | Get-XrmRecord -LogicalName "webresource" -Id $Id -Columns "name", "content" -IfExists -AsEntity;
            $description = "Web resource '$Id'";
        }
        else {
            $webResource = $XrmClient | Get-XrmRecord -LogicalName "webresource" -AttributeName "name" -Value $Name -Columns "name", "content" -AsEntity;
            $description = "Web resource '$Name'";
        }
        if (-not $webResource) {
            throw "$description not found.";
        }

        $relativePath = ([string]$webResource["name"]).Replace('/', [System.IO.Path]::DirectorySeparatorChar);
        $filePath = [System.IO.Path]::Combine($OutputPath, $relativePath);
        $folder = [System.IO.Path]::GetDirectoryName($filePath);
        if (-not (Test-Path $folder)) {
            New-Item -ItemType Directory -Path $folder -Force | Out-Null;
        }
        $content = [string]$webResource["content"];
        $bytes = $(if ([string]::IsNullOrEmpty($content)) { [byte[]]@() } else { [Convert]::FromBase64String($content) });
        [System.IO.File]::WriteAllBytes($filePath, $bytes);
        $filePath;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Export-XrmWebResource -Alias *;
