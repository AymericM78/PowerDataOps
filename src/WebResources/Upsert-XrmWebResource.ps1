<#
    .SYNOPSIS
    Create or update webresource.

    .DESCRIPTION
    Check if webresource exists or not. If not exists create it and add it to specified solution.
    If webresource exists, compare content and update it if different.
    By default, returns the webresource id only when it was created or updated (to build a publish request), and skips silently a file whose name does not start with the prefix.
    With PassThru, always returns an object: Id, Name, Changed, Skipped.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER FilePath
    Local webresource file path.

    .PARAMETER SolutionUniqueName
    Microsoft Dataverse solution unique name where to add new webressource.

    .PARAMETER Prefix
    Publisher customization prefix for newly created webresource. (Default: prefix of the solution publisher)

    .PARAMETER DisplayName
    Webresource display name. (Default: file name)

    .PARAMETER PassThru
    Always return an object: Id, Name, Changed (created or updated), Skipped (name without the prefix, nothing done).

    .OUTPUTS
    Guid. The webresource id, when created or updated. With PassThru: PSCustomObject (Id, Name, Changed, Skipped).

    .EXAMPLE
    $webResourceId = Upsert-XrmWebResource -XrmClient $xrmClient -FilePath "C:\Sources\WebResources\new_\scripts\account.js" -SolutionUniqueName "MySolution";

    .EXAMPLE
    $result = Upsert-XrmWebResource -XrmClient $xrmClient -FilePath $path -SolutionUniqueName "MySolution" -PassThru;
    if ($result.Changed) { Publish-XrmComponent -XrmClient $xrmClient -ComponentName "webresource" -ComponentId $result.Id; }

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmWebResource.md
#>

function Upsert-XrmWebResource {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Guid], [PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [string]
        $FilePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Prefix,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $DisplayName,

        [Parameter(Mandatory = $false)]
        [switch]
        $PassThru
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        if (-not $PSBoundParameters.Prefix) {
            # Resolve publisher prefix for given solution
            $solution = $XrmClient | Get-XrmRecord -LogicalName "solution" -AttributeName "uniquename" -Value $SolutionUniqueName -Columns "publisherid";
            $publisher = $XrmClient | Get-XrmRecord -LogicalName "publisher" -Id $solution.publisherid_Value.Id -Columns "customizationprefix";
            $Prefix = "$($publisher.customizationprefix)_";
        }

        # Handle prefix in file name
        $fileInfo = New-Object -TypeName System.IO.FileInfo -ArgumentList $filePath;
        $webResourcePath = $fileInfo.FullName;
        $webResourceName = $fileInfo.Name;
        $extension = $fileInfo.Extension;

        if ($webResourceName.StartsWith($Prefix) -eq $false) {
            $position = $webResourcePath.LastIndexOf($Prefix);
            if ($position -gt 0) {
                $webResourceName = $webResourcePath.Substring($position);
                $webResourceName = $webResourceName.Replace('\', '/');
            }
        }

        if (!$webResourceName.StartsWith($Prefix)) {
            # Ignore this file: its name (or path) does not contain the publisher prefix
            Write-Verbose "Webresource file '$webResourcePath' skipped: name does not start with prefix '$Prefix'.";
            if ($PassThru) {
                [PSCustomObject]@{
                    Id      = $null;
                    Name    = $webResourceName;
                    Changed = $false;
                    Skipped = $true;
                };
            }
            return;
        }

        # Load webresource object from path
        if (!$DisplayName) {
            $webResourceDisplayName = $webResourceName;
            $index = $webResourceDisplayName.LastIndexOf("/") + 1;
            $webResourceDisplayName = $webResourceDisplayName.Substring($index, ($webResourceDisplayName.Length - $index));
        }
        else {
            $webResourceDisplayName = $DisplayName;
        }

        # Get resource type from extension
        # https://docs.microsoft.com/en-us/dynamics365/customer-engagement/developer/entities/webresource#webresourcetype-options
        #   1	Webpage (HTML)
        #   2	Style Sheet (CSS)
        #   3	Script (JScript)
        #   4	Data (XML)
        #   5	PNG format
        #   6	JPG format
        #   7	GIF format
        #   8	Silverlight (XAP)
        #   9	Style Sheet (XSL)
        #   10	ICO format
        #   11	Vector format (SVG)
        #   12	String (RESX)
        switch ($extension.ToLower()) {
            ".htm" { $webresourceType = 1; }
            ".html" { $webresourceType = 1; }
            ".css" { $webresourceType = 2; }
            ".js" { $webresourceType = 3; }
            ".xml" { $webresourceType = 4; }
            ".png" { $webresourceType = 5; }
            ".jpg" { $webresourceType = 6; }
            ".jpeg" { $webresourceType = 6; }
            ".gif" { $webresourceType = 7; }
            ".xap" { $webresourceType = 8; }
            ".xsl" { $webresourceType = 9; }
            ".ico" { $webresourceType = 10; }
            ".svg" { $webresourceType = 11; }
            ".resx" { $webresourceType = 12; }
            default { Write-HostAndLog "Unkown webresource extension : $extension" -ForegroundColor Red -NoTimeStamp; }
        }
        $webResourceContent = (Get-XrmBase64 -FilePath $filePath);
        $webresourceRecord = New-XrmEntity -LogicalName "webresource" -Attributes @{
            name            = $webResourceName
            displayname     = $webResourceDisplayName
            content         = $webResourceContent
            webresourcetype = (New-XrmOptionSetValue -Value $webresourceType)
        };
        $ignore = $true;
        $existingWebResource = Get-XrmRecord -XrmClient $XrmClient -LogicalName "webresource" -AttributeName "name" -Value $webResourceName -Columns "content";
        if (-not $existingWebResource) {
            $createdId = $XrmClient | Add-XrmRecord -Record $webresourceRecord;
            # Skipped by -WhatIf, or failed (the error is already written)
            if (-not $createdId) {
                return;
            }
            $webresourceRecord.Id = $createdId;
            $ignore = $false;
        }
        else {
            $webresourceRecord.Id = $existingWebResource.Id;
            if ($webResourceContent -ne $existingWebResource.content) {
                $ignore = $false;
                $XrmClient | Update-XrmRecord -Record $webresourceRecord;
            }
        }

        if ($PSBoundParameters.SolutionUniqueName) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -ComponentId $webresourceRecord.Id -ComponentType 61 -SolutionUniqueName $SolutionUniqueName -DoNotIncludeSubcomponents $false | Out-Null;
        }

        if ($PassThru) {
            [PSCustomObject]@{
                Id      = $webresourceRecord.Id;
                Name    = $webResourceName;
                Changed = (-not $ignore);
                Skipped = $false;
            };
        }
        elseif (-not $ignore) {
            # Return webresource id if created/updated in order to add it to a publish request
            $webresourceRecord.Id;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmWebResource -Alias *;
