<#
    .SYNOPSIS
    Explore connection files.
#>
function Get-XrmConnection {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [Switch]
        $ListAvailable,

        [Parameter(Mandatory = $false)]
        [switch]
        $DoNotDecryptPassword        
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
        $Global:XrmContext = New-XrmContext;
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $name = $PSBoundParameters.Name;
        $instanceName = $PSBoundParameters.InstanceName;
               
        if ($name) {  
            $targetFilePath = [IO.Path]::Combine($Global:PowerDataOpsModuleFolderPath, "$name.xml");
            
            $xrmConnection = Import-XrmConnection -FilePath $targetFilePath -DoNotDecryptPassword:$DoNotDecryptPassword;
            $Global:XrmContext.CurrentConnection = $xrmConnection;

            if ($instanceName) {
                $xrmInstance = $xrmConnection.Instances | Where-Object -Property "Name" -EQ -Value $instanceName;
                $Global:XrmContext.CurrentInstance = $xrmInstance;
                $xrmInstance;                
            }
            else {
                if ($ListAvailable) {                    
                    $xrmConnection.Instances;
                }
                $xrmConnection;
            }
        }
        else {                          
            $files = Get-ChildItem -Path $Global:PowerDataOpsModuleFolderPath -Include "*.xml" -Recurse;
            $connections = @();
            foreach ($file in $files) {
                $xrmConnection = Import-XrmConnection -FilePath $file.FullName -DoNotDecryptPassword:$DoNotDecryptPassword;
                $connections += $xrmConnection;
            }
            $connections;
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

    $fileNames = @(Get-ChildItem -Path $Global:PowerDataOpsModuleFolderPath -Include "*.xml" -Recurse | Select-Object -Property BaseName);
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
    $targetFilePath = [IO.Path]::Combine($Global:PowerDataOpsModuleFolderPath, $fileName);
    $xrmConnection = Import-XrmConnection -FilePath $targetFilePath;

    $validInstanceNames = @();
    $xrmConnection.Instances | Sort-Object -Property Name | ForEach-Object {
        $validInstanceNames += $_.Name;
    }           
    return $validInstanceNames | Where-Object { $_ -like "$wordToComplete*" };
}