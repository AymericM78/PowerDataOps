# Create Browser shortcut and push to desktop
# https://www.ghacks.net/2013/10/06/list-useful-google-Browser-command-line-switches/
function Add-BrowserShortcut {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $BrowserShortCutsPath,

        [Parameter(Mandatory = $true)]
        [string]
        $BrowserAppPath,

        [Parameter(Mandatory = $true)]
        [string]
        $ProfileName
    )    

    Write-HostAndLog "Add browser shortcut to '$BrowserShortCutsPath'... " -NoNewline -ForegroundColor Gray;
    
    $name = $ProfileName.Replace("Profile ", "");    
    $shortcutPath = "$($BrowserShortCutsPath)\$($name).lnk";
    # TODO : Check if shortcut exists before
    $arguments = " --profile-directory=`"$($ProfileName)`" ";

    $shell = New-Object -ComObject WScript.Shell;
    $shortcut = $shell.CreateShortcut($shortcutPath);
    $shortcut.TargetPath = $BrowserAppPath;
    $shortcut.Arguments = $arguments;
    $shortcut.Save();
    Write-HostAndLog "[OK]" -ForegroundColor Green -NoTimeStamp;
}

function Set-BrowserFavoriteBarEnabled {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ProfilePath,

        [Parameter(Mandatory = $true)]
        [string]
        $ProfileName
    )    

    Write-HostAndLog "Configure browser favorite bar... " -NoNewline -ForegroundColor Gray;
    $preferencesFilePath = "$ProfilePath\Preferences";
    $preferencesFileContent = [IO.File]::ReadAllText($preferencesFilePath);
    $preferencesJson = $preferencesFileContent | ConvertFrom-Json;
    
    $bookmark_bar = ConvertFrom-Json '{ "show_on_all_tabs": true }';

    $preferencesJson.profile.name = $ProfileName;
    
    $preferencesJson | Add-Member -MemberType NoteProperty -Name bookmark_bar -Value $bookmark_bar -ErrorAction Ignore;     
    $preferencesJson | ConvertTo-Json -Depth 32 | Out-File -FilePath $preferencesFilePath -Encoding utf8 -Force;
    Write-HostAndLog "[OK]" -ForegroundColor Green -NoTimeStamp;
}

function Start-Browser {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $BrowserAppPath,

        [Parameter(Mandatory = $true)]
        [string]
        $ProfileName
    )    

    Write-HostAndLog "Starting browser... " -NoNewline -ForegroundColor Gray;
    $arguments = " --profile-directory=`"$($ProfileName)`" ";
    $proc = Start-Process -FilePath $BrowserAppPath -ArgumentList $arguments -PassThru;
    Write-HostAndLog "[OK]" -ForegroundColor Green -NoTimeStamp;
}

function Add-ChromeExtension {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ExtensionName
    )  
    
    Write-HostAndLog "Add Chrome extension '$ExtensionName' ... " -NoNewline -ForegroundColor Gray;
    New-Item -Path "HKCU:\Software\Google\Chrome\Extensions" -Name $ExtensionName -Force | Out-Null;
    New-ItemProperty -Path "HKCU:\Software\Google\Chrome\Extensions\$ExtensionName" -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -PropertyType String -Force | Out-Null;
    Write-HostAndLog "[OK]" -ForegroundColor Green -NoTimeStamp;
}

function Add-EdgeExtension {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ExtensionName
    )  
    
    Write-HostAndLog "Add Chrome extension '$ExtensionName' ... " -NoNewline -ForegroundColor Gray;
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Edge\Extensions" -Name $ExtensionName -Force | Out-Null;
    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Edge\Extensions\$ExtensionName" -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -PropertyType String -Force | Out-Null;
    Write-HostAndLog "[OK]" -ForegroundColor Green -NoTimeStamp;
}

class BookMark {
    [String]$date_added = "13244290348204144";
    #[String]$date_modified = "13244290348204144";
    [String]$guid = [guid]::NewGuid();
    [String]$id = [Random]::new().Next(1, 999).ToString();
    [String]$name;
    [String]$type;

    BookMark () {
    }

    [void] AddChild([BookMark] $bookmark) {
        $this.children += $bookmark;    
    }

    [BookMark] AddChild([String]$Name) {
        $bookmark = [FolderBookMark]::New($Name)
        $this.children += $bookmark;  
        return $bookmark;  
    }

    [void] AddChild([String]$Name, [String]$Url) {
        $bookmark = [UrlBookMark]::New($Name, $Url)
        $this.children += $bookmark;    
    }

    [BookMark] GetChild([String]$Name) {
        $bookmark = $this.children | Where-Object -Property name -EQ $Name;
        return $bookmark;  
    }
}

class UrlBookMark :  BookMark {
    [String]$url;
    
    UrlBookMark ([String]$Name, [String]$Url) {
        $this.name = $Name;
        $this.url = $Url;
        $this.type = "url";
    }
}

class FolderBookMark :  BookMark {
    [BookMark[]]$children = @();
    
    FolderBookMark ([String]$Name) {
        $this.name = $Name;
        $this.type = "folder";
    }
}

function Get-DefaultBookmark {    
    Write-HostAndLog "Get default favorites... " -NoNewline -ForegroundColor Gray;
    $mainFolder = [FolderBookMark]::New("!NEW FAVORITES!");

    $o365Folder = $mainFolder.AddChild("O365");
    $o365Folder.AddChild("Admin", "https://admin.microsoft.com/AdminPortal/Home#/homepage");
    $o365Folder.AddChild("O365", "https://www.office.com");
    $o365Folder.AddChild("OWA", "https://outlook.office365.com/mail/inbox");
    $o365Folder.AddChild("Teams", "https://teams.microsoft.com");

    $powerPlatformFolder = $mainFolder.AddChild("Power Platform");
    $powerPlatformFolder.AddChild("Power Platform Admin", "https://admin.powerplatform.microsoft.com");
    $powerPlatformFolder.AddChild("Power Apps Maker", "https://make.powerapps.com");
    $powerPlatformFolder.AddChild("Power Automate (Flow)", "https://flow.microsoft.com/");
    $powerPlatformFolder.AddChild("Power BI", "https://app.powerbi.com");
    
    $cdsFolder = $mainFolder.AddChild("Dataverse");
    $cdsFolder.AddChild("Power Platform Admin", "https://admin.powerplatform.microsoft.com");
    $cdsFolder.AddChild("Power Apps Maker", "https://make.powerapps.com");
    $cdsFolder.AddChild("Customer Voice", "https://customervoice.microsoft.com/");
    
    $azureFolder = $mainFolder.AddChild("Azure");
    $azureFolder.AddChild("Azure", "https://portal.azure.com");
    $azureFolder.AddChild("Azure DevOps", "https://dev.azure.com");

    Write-HostAndLog "[OK]" -ForegroundColor Green -NoTimeStamp;
    return $mainFolder;
}

function Save-BookMark {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ProfilePath,

        [Parameter(Mandatory = $true)]
        [FolderBookMark]
        $RootBookmark
    )  
    
    $bookmarksFilePath = "$ProfilePath\Bookmarks";
    Write-HostAndLog "Saving favorites to '$bookmarksFilePath'... " -NoNewline -ForegroundColor Gray;

    if (-not (Test-Path -Path $bookmarksFilePath)) {
        $bookmarkDefaultContent = '{
            "checksum": "4ff448b8f4bc5ef36f5e05aab3218bca",
            "roots": {
                "bookmark_bar": {
                    "children": [  ],
                    "date_added": "13231958894390217",
                    "date_modified": "13231960751123696",
                    "guid": "00000000-0000-4000-A000-000000000002",
                    "id": "1",
                    "name": "Barre de favoris",
                    "type": "folder"
                },
                "other": {
                    "children": [  ],
                    "date_added": "13231958894390228",
                    "date_modified": "0",
                    "guid": "00000000-0000-4000-A000-000000000003",
                    "id": "2",
                    "name": "Autres favoris",
                    "type": "folder"
                },
                "synced": {
                    "children": [  ],
                    "date_added": "13231958894390231",
                    "date_modified": "0",
                    "guid": "00000000-0000-4000-A000-000000000004",
                    "id": "3",
                    "name": "Favoris sur mobile",
                    "type": "folder"
                }
            },
            "version": 1
            }';
        $bookmarkDefaultContent | Out-File -FilePath $bookmarksFilePath -Encoding utf8 -Force;
    }

    $bookmarkContent = [IO.File]::ReadAllText($bookmarksFilePath);
    $bookmark = $bookmarkContent | ConvertFrom-Json;

    # Remove existing "!NEW FAVORITES!" nodes
    $children = @();
    foreach ($node in $bookmark.roots.bookmark_bar.children) {
        if ($node.name -eq "!NEW FAVORITES!") {
            continue;
        }
        $children += $node;
    }
    $bookmark.roots.bookmark_bar.children = $children;

    # Configure chrome : Add favorites
    $bookmark.roots.bookmark_bar.children += $RootBookmark;

    $bookmarkContent = $bookmark | ConvertTo-Json -Depth 32;
    $bookmarkContent | Out-File -FilePath $bookmarksFilePath -Encoding utf8 -Force;
    Write-HostAndLog "[OK]" -ForegroundColor Green -NoTimeStamp;
}

function Get-XrmFavorites {
    param (
        [Parameter(Mandatory = $true)]
        [FolderBookMark]
        $RootBookmark,

        [Parameter(Mandatory = $false)]
        [String]
        $OverrideConnectionStringFormat = "",

        [Parameter(Mandatory = $false)]
        [String[]]
        $AppIgnoredList = @()
    )      

    Write-HostAndLog "Retrieving Dataverse links... " -ForegroundColor Gray;
    $d365Folder = $RootBookmark.GetChild("Dataverse");

    $instances = Get-XrmInstances;

    $queryApps = New-Object "Microsoft.Xrm.Sdk.Query.QueryExpression" -ArgumentList "appmodule";
    $queryApps.Columnset.AddColumn("uniquename");
    $queryApps.Columnset.AddColumn("name");
    $queryApps.Criteria.AddCondition("clienttype", [Microsoft.Xrm.Sdk.Query.ConditionOperator]::Equal, 4);

    # Retrieve Dataverse apps
    foreach ($instance in $instances) {
        Write-HostAndLog "  > Connecting to " -NoNewline -NoTimeStamp -ForegroundColor Gray;
        Write-HostAndLog $instance.DisplayName -NoNewline -NoTimeStamp -ForegroundColor Yellow;
        Write-HostAndLog " instance..." -NoNewline -NoTimeStamp -ForegroundColor Gray;

        if (-not $instance.Url) {
            Write-HostAndLog "[Ignored]" -NoTimeStamp -ForegroundColor Gray;
            continue;
        }

        $crmConnectionString = $instance | Out-XrmConnectionString;
        
        if (-not [string]::IsNullOrWhiteSpace($OverrideConnectionStringFormat)) {
            $crmConnectionString = $OverrideConnectionStringFormat.Replace("{Url}", $instance.Url);
        }

        try {
            $xrmClient = New-XrmClient -ConnectionString $crmConnectionString -Quiet;
            $url = $instance.Url;
            $instanceFolder = $d365Folder.AddChild($instance.DisplayName);
            $instanceFolder.AddChild("Home", "$url/main.aspx?forceUCI=1&pagetype=apps");
            $instanceFolder.AddChild("Admin", "$url/main.aspx?settingsonly=true");
            
            $adminFolder = $instanceFolder.AddChild("Admin Center");
            $envId = $xrmClient.EnvironmentId;
            $orgId = $xrmClient.ConnectedOrgId.Guid;
            $adminFolder.AddChild("Admin Center", "https://admin.powerplatform.microsoft.com/environments/environment/$envId/hub");
            $adminFolder.AddChild("Settings", "https://admin.powerplatform.microsoft.com/environments/$orgId/Settings");
            $adminFolder.AddChild("Users", "https://admin.powerplatform.microsoft.com/environments/$orgId/$envId/users");
            $adminFolder.AddChild("App Users", "https://admin.powerplatform.microsoft.com/environments/$orgId/appusers");
            
            $apps = $xrmClient | Get-XrmMultipleRecords -Query $queryApps;
            foreach ($app in $apps) {
                $appName = $app.uniquename;
                if ($AppIgnoredList.Contains($appName)) {
                    continue;
                }
                # https://*.dynamics.com/Apps/uniquename/*uniquename*
                $appUrl = "$url/Apps/uniquename/$($appName)";
                $instanceFolder.AddChild($app.name, $appUrl);
            }
            Write-HostAndLog "[OK]" -NoTimeStamp -ForegroundColor Green;
        }
        catch {
            Write-HostAndLog "[KO] => Reason: $($_.Exception.Message))" -ForegroundColor Red;
            continue;
        }
    }
    return $RootBookmark;
}