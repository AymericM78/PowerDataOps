<#
    .SYNOPSIS
    Get connections from XrmToolBox.

    .DESCRIPTION
    Browse and retrieve information from XrmToolBox saved connections.

    .PARAMETER ListAvailable
    Specify if you want to see all connections or all instances.

    .PARAMETER XtbConnectionPath
    XTB connections folder path. (Default: $env:APPDATA\MscrmTools\XrmToolBox\Connections)
#>
function Get-XrmConnection {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [Switch]
        $ListAvailable,

        [Parameter(Mandatory = $false)]
        [String]
        $XtbConnectionPath = "$env:APPDATA\MscrmTools\XrmToolBox\Connections"
    )
    dynamicparam {
        $dynamicParameters = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary;
             
        # Define Dynamic Parameter : Name
        $nameParameterAttributes = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute];
        $nameParameterAttribute = New-Object System.Management.Automation.ParameterAttribute;
        $nameParameterAttribute.Mandatory = (-not $ListAvailable);        
        $nameParameterAttributes.Add($nameParameterAttribute);        
        $nameParameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter("Name", [string], $nameParameterAttributes);
        $dynamicParameters.Add("Name", $nameParameter);
                                 
        # Define Dynamic Parameter : InstanceName
        $instanceNameParameterAttributes = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute];
        $instanceNameParameterAttribute = New-Object System.Management.Automation.ParameterAttribute;
        $instanceNameParameterAttributes.Add($instanceNameParameterAttribute);        
        $instanceNameParameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter("InstanceName", [string], $instanceNameParameterAttributes);
        $dynamicParameters.Add("InstanceName", $instanceNameParameter);
              
        return $dynamicParameters;    
    }
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $name = $PSBoundParameters.Name;
        $instanceName = $PSBoundParameters.InstanceName;
               
        if ($PSBoundParameters.ContainsKey('Name')) {  
            $targetFilePath = "$XtbConnectionPath\$($Name).xml";
            
            $connection = Import-XrmConnection -FilePath $targetFilePath;
            if (-not $Global:XrmContext) {
                $Global:XrmContext = New-XrmContext;
            }
            $Global:XrmContext.CurrentConnection = $connection;

            if ($PSBoundParameters.ContainsKey('InstanceName')) {
                $instance = $connection.Instances | Where-Object -Property "Name" -EQ -Value $InstanceName;
                $Global:XrmContext.CurrentInstance = $instance;
                $instance;                
            }
            else {
                if ($ListAvailable) {                    
                    $connection.Instances;
                }
                $connection;
            }
        }
        else {            
            $xtbConnectionFilePath = "$XtbConnectionPath\MscrmTools.ConnectionsList.xml"
            $xtbContent = [xml] [IO.File]::ReadAllText($xtbConnectionFilePath);

            $connections = @();
            foreach ($file in $xtbContent.ConnectionsList.Files.ConnectionFile) {
                $connection = Import-XrmConnection -FilePath $file.Path;
                $connections += $connection;
            }
            $connections | Select-Object Name;
        }   
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmConnection -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmConnection -ParameterName "Name" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $fileNames = @(Get-ChildItem -Path "$env:APPDATA\MscrmTools\XrmToolBox\Connections" -Include "*.xml" -Recurse | Select-Object -Property BaseName);
    $validNames = @();
    $fileNames | Sort-Object -Property BaseName  | ForEach-Object {
        $validNames += $_.BaseName;
    }
    return $validNames | Where-Object { $_ -like "$wordToComplete*" };
}

Register-ArgumentCompleter -CommandName Get-XrmConnection -ParameterName "InstanceName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    if (-not ($fakeBoundParameters.ContainsKey("Name"))) {
        return @();
    }
    $fileName = "$($fakeBoundParameters.Name).xml"; 
    $targetFilePath = [IO.Path]::Combine("$env:APPDATA\MscrmTools\XrmToolBox\Connections", $fileName);
    $connection = Import-XrmConnection -FilePath $targetFilePath;

    $validInstanceNames = @();
    $connection.Instances | Sort-Object -Property Name | ForEach-Object {
        $validInstanceNames += $_.Name;
    }           
    return $validInstanceNames | Where-Object { $_ -like "$wordToComplete*" };
}