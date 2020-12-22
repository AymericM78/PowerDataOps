<#
    .SYNOPSIS
    Export instances collection to XML file with connection strings.
#>

function Protect-XrmPassword($pass)
{
    $protectedPassword = ConvertTo-SecureString -string $pass -asplaintext -force;
    $protectedPasswordString = ConvertFrom-SecureString -SecureString $protectedPassword;
    return $protectedPasswordString;
}

function Export-XrmConnection {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline = $True)]
        [Object]
        $XrmConnection
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $securePwd = Protect-XrmPassword -pass $XrmConnection.UserPassword;

        # TODO : Use JSON serialization
        $instanceLineTemplate = "`t`t<Instance Id=`"[Id]`" Name=`"[Name]`" UniqueName=`"[UniqueName]`" DisplayName=`"[DisplayName]`" ConnectionString=`"[ConnectionString]`" `
        Url=`"[Url]`" AdminApiUrl=`"[AdminApiUrl]`" ApiUrl=`"[ApiUrl]`" TenantId=`"[TenantId]`" EnviromentId=`"[EnviromentId]`" />";

        $output = New-Object -TypeName "System.Text.StringBuilder";
        $output.AppendLine("<?xml version=`"1.0`" encoding=`"utf-8`"?>") | Out-Null;
        $output.AppendLine("<Connection>") | Out-Null;

        $output.AppendLine("`t<Name>$($XrmConnection.Name)</Name>") | Out-Null;
        $output.AppendLine("`t<FilePath>$($XrmConnection.FilePath)</FilePath>") | Out-Null;
        $output.AppendLine("`t<AuthType>$($XrmConnection.AuthType)</AuthType>") | Out-Null;
        $output.AppendLine("`t<UserName>$($XrmConnection.UserName)</UserName>") | Out-Null;
        $output.AppendLine("`t<UserPassword>$securePwd</UserPassword>") | Out-Null;
        $output.AppendLine("`t<Region>$($XrmConnection.Region)</Region>") | Out-Null;
        $output.AppendLine("`t<ConnectionStringParameters>$($XrmConnection.ConnectionStringParameters)</ConnectionStringParameters>") | Out-Null;
        
        $output.AppendLine("`t<DevOps>") | Out-Null;
        $output.AppendLine("`t`t<OrganizationName>$($XrmConnection.DevOpsSettings.OrganizationName)</OrganizationName>") | Out-Null;
        $output.AppendLine("`t`t<ProjectName>$($XrmConnection.DevOpsSettings.ProjectName)</ProjectName>") | Out-Null;
        $output.AppendLine("`t`t<Token>$($XrmConnection.DevOpsSettings.Token)</Token>") | Out-Null;
        $output.AppendLine("`t</DevOps>") | Out-Null;

        $output.AppendLine("`t<Instances>") | Out-Null;
        foreach ($instance in $XrmConnection.Instances) {   
            $instanceLineContent = $instanceLineTemplate;

            $instance.ConnectionString = $instance | Out-XrmConnectionString;
            $instance.ConnectionString = $instance.ConnectionString.Replace($XrmConnection.UserPassword, $securePwd);

            $instanceLineContent = $instanceLineContent.Replace("[Id]", $instance.Id);
            $instanceLineContent = $instanceLineContent.Replace("[Name]", $instance.Name);
            $instanceLineContent = $instanceLineContent.Replace("[UniqueName]", $instance.UniqueName);
            $instanceLineContent = $instanceLineContent.Replace("[DisplayName]", $instance.DisplayName);
            $instanceLineContent = $instanceLineContent.Replace("[ConnectionString]", $instance.ConnectionString);
            $instanceLineContent = $instanceLineContent.Replace("[Url]", $instance.Url);
            $instanceLineContent = $instanceLineContent.Replace("[AdminApiUrl]", $instance.AdminApiUrl);
            $instanceLineContent = $instanceLineContent.Replace("[ApiUrl]", $instance.ApiUrl);
            $instanceLineContent = $instanceLineContent.Replace("[TenantId]", $instance.TenantId);
            $instanceLineContent = $instanceLineContent.Replace("[EnviromentId]", $instance.EnviromentId);

            $output.AppendLine($instanceLineContent) | Out-Null;
        }
        $output.AppendLine("`t</Instances>") | Out-Null;
        $output.AppendLine("</Connection>") | Out-Null;
        $output.ToString() | Out-File -FilePath $XrmConnection.FilePath -Encoding utf8 -Force;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Export-XrmConnection -Alias *;