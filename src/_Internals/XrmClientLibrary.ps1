function ConvertTo-XrmConnectionStringMapInternal {
    param(
        [string]
        $RawConnectionString
    );

    $parameters = [ordered]@{};
    if ([string]::IsNullOrWhiteSpace($RawConnectionString)) {
        return $parameters;
    }

    $RawConnectionString.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {
        $connectionStringSegment = $_.Trim();
        if (-not [string]::IsNullOrWhiteSpace($connectionStringSegment)) {
            $separatorIndex = $connectionStringSegment.IndexOf('=');
            if ($separatorIndex -gt 0) {
                $parameterName = $connectionStringSegment.Substring(0, $separatorIndex).Trim();
                $parameterValue = $connectionStringSegment.Substring($separatorIndex + 1).Trim();
                $normalizedParameterName = $parameterName.Replace(' ', '').ToLowerInvariant();
                if (-not [string]::IsNullOrWhiteSpace($normalizedParameterName)) {
                    $parameters[$normalizedParameterName] = [PSCustomObject]@{
                        Name = $parameterName;
                        Value = $parameterValue;
                    };
                }
            }
        }
    };

    return $parameters;
}


function Get-XrmConnectionStringValueInternal {
    param(
        [System.Collections.IDictionary]
        $Parameters,

        [string[]]
        $Names
    );

    foreach ($name in $Names) {
        $normalizedName = $name.Replace(' ', '').ToLowerInvariant();
        if ($Parameters.Contains($normalizedName)) {
            return [string]$Parameters[$normalizedName].Value;
        }
    }

    return $null;
}


function Set-XrmConnectionStringValueInternal {
    param(
        [System.Collections.IDictionary]
        $Parameters,

        [string]
        $Name,

        [string]
        $Value
    );

    $normalizedName = $Name.Replace(' ', '').ToLowerInvariant();
    if ($Parameters.Contains($normalizedName)) {
        $Parameters[$normalizedName].Name = $Name;
        $Parameters[$normalizedName].Value = $Value;
    }
    else {
        $Parameters[$normalizedName] = [PSCustomObject]@{
            Name = $Name;
            Value = $Value;
        };
    }
}


function ConvertFrom-XrmConnectionStringMapInternal {
    param(
        [System.Collections.IDictionary]
        $Parameters
    );

    $segments = @();
    foreach ($parameter in $Parameters.Values) {
        $segments += "$($parameter.Name)=$($parameter.Value)";
    }

    if ($segments.Count -eq 0) {
        return $null;
    }

    return (($segments -join ';') + ';');
}


function Get-XrmExceptionDetailsInternal {
    param(
        [System.Exception]
        $Exception
    );

    if ($null -eq $Exception) {
        return $null;
    }

    $messages = @();
    $currentException = $Exception;
    while ($null -ne $currentException) {
        $message = $currentException.Message;
        if (-not ($currentException.InnerException -and $message -like 'Exception calling*') -and -not [string]::IsNullOrWhiteSpace($message) -and $messages -notcontains $message) {
            $messages += $message;
        }
        $currentException = $currentException.InnerException;
    }

    return ($messages -join ' | ');
}


function Get-XrmClientFailureInternal {
    param(
        [Parameter(Mandatory = $false)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $Client,

        [Parameter(Mandatory = $false)]
        [System.Exception]
        $Exception
    );

    $lastError = $null;
    $lastException = $null;

    if ($null -ne $Client) {
        foreach ($propertyName in @('LastError', 'LastCrmError')) {
            $property = $Client.PSObject.Properties[$propertyName];
            if ($null -ne $property -and -not [string]::IsNullOrWhiteSpace([string]$property.Value)) {
                $lastError = [string]$property.Value;
                break;
            }
        }

        foreach ($propertyName in @('LastException', 'LastCrmException')) {
            $property = $Client.PSObject.Properties[$propertyName];
            if ($null -ne $property -and $null -ne $property.Value) {
                $lastException = $property.Value;
                break;
            }
        }
    }

    if ($null -ne $Exception -and $null -eq $lastException) {
        $lastException = $Exception;
    }

    $exceptionDetails = Get-XrmExceptionDetailsInternal -Exception $lastException;
    if (-not [string]::IsNullOrWhiteSpace($exceptionDetails)) {
        if (-not [string]::IsNullOrWhiteSpace($lastError) -and $exceptionDetails -notlike "*$lastError*") {
            $lastError = "$lastError | $exceptionDetails";
        }
        else {
            $lastError = $exceptionDetails;
        }
    }

    if ([string]::IsNullOrWhiteSpace($lastError)) {
        $lastError = 'Failed to connect to Dataverse.';
    }

    return [PSCustomObject]@{
        Message = $lastError;
        Exception = $lastException;
    };
}


function Resolve-XrmClientConnectionStringInternal {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ConnectionString,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsEncrypted = $false
    );

    if ($IsEncrypted) {
        $ConnectionString = Repair-XrbConnectionString -ConnectionString $ConnectionString;
    }

    $authType = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName 'AuthType';
    if ($authType -eq 'Office365') {
        $ConnectionString = $ConnectionString.Replace('Office365', 'OAuth');
        $authType = 'OAuth';
    }

    $connectionStringParameters = ConvertTo-XrmConnectionStringMapInternal -RawConnectionString $ConnectionString;
    $password = Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('Password');
    $clientSecret = Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('ClientSecret', 'Secret');
    $thumbprint = Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('Thumbprint', 'CertThumbprint');
    $serviceUrl = Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('Url', 'ServiceUri', 'Service Uri', 'Server');
    $hasExplicitCredentials = -not [string]::IsNullOrWhiteSpace($password) -or -not [string]::IsNullOrWhiteSpace($clientSecret) -or -not [string]::IsNullOrWhiteSpace($thumbprint);
    $shouldUseInteractiveFallback = $hasExplicitCredentials -eq $false -and ([string]::IsNullOrWhiteSpace($authType) -or $authType -eq 'OAuth');

    if ($shouldUseInteractiveFallback) {
        if ([string]::IsNullOrWhiteSpace($serviceUrl)) {
            throw 'New-XrmClient interactive authentication requires a connection string containing Url=<DataverseUrl>.';
        }

        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AuthType' -Value 'OAuth';

        if ([string]::IsNullOrWhiteSpace((Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('AppId', 'ClientId', 'ApplicationId')))) {
            Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AppId' -Value '51f81489-12ee-4a9e-aaae-a2591f45987d';
        }

        if ([string]::IsNullOrWhiteSpace((Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('RedirectUri', 'ReplyUrl')))) {
            Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'RedirectUri' -Value 'http://localhost';
        }

        if ([string]::IsNullOrWhiteSpace((Get-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Names @('LoginPrompt')))) {
            Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'LoginPrompt' -Value 'Auto';
        }

        $ConnectionString = ConvertFrom-XrmConnectionStringMapInternal -Parameters $connectionStringParameters;
    }

    return $ConnectionString;
}


function New-XrmClientConnectionStringInternal {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Url,

        [Parameter(Mandatory = $false)]
        [string]
        $UserName,

        [Parameter(Mandatory = $false)]
        [string]
        $Password,

        [Parameter(Mandatory = $false)]
        [string]
        $ClientId,

        [Parameter(Mandatory = $false)]
        [string]
        $ClientSecret,

        [Parameter(Mandatory = $false)]
        [string]
        $CertificateThumbprint,

        [Parameter(Mandatory = $false)]
        [string]
        $RedirectUri,

        [Parameter(Mandatory = $false)]
        [string]
        $LoginPrompt
    );

    if ([string]::IsNullOrWhiteSpace($Url)) {
        throw 'Connect-XrmClient requires Url=<DataverseUrl>.';
    }

    $connectionStringParameters = [ordered]@{};
    Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'Url' -Value $Url;

    if (-not [string]::IsNullOrWhiteSpace($ClientSecret)) {
        if ([string]::IsNullOrWhiteSpace($ClientId)) {
            throw 'Connect-XrmClient client secret authentication requires -ClientId.';
        }

        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AuthType' -Value 'ClientSecret';
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'ClientId' -Value $ClientId;
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'ClientSecret' -Value $ClientSecret;

        return ConvertFrom-XrmConnectionStringMapInternal -Parameters $connectionStringParameters;
    }

    if (-not [string]::IsNullOrWhiteSpace($CertificateThumbprint)) {
        if ([string]::IsNullOrWhiteSpace($ClientId)) {
            throw 'Connect-XrmClient certificate authentication requires -ClientId.';
        }

        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AuthType' -Value 'Certificate';
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'ClientId' -Value $ClientId;
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'Thumbprint' -Value $CertificateThumbprint;

        return ConvertFrom-XrmConnectionStringMapInternal -Parameters $connectionStringParameters;
    }

    $hasUserName = -not [string]::IsNullOrWhiteSpace($UserName);
    $hasPassword = -not [string]::IsNullOrWhiteSpace($Password);

    if ($hasPassword -and -not $hasUserName) {
        throw 'Connect-XrmClient username/password authentication requires both -UserName and -Password.';
    }

    Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AuthType' -Value 'OAuth';

    if ($hasUserName) {
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'Username' -Value $UserName;
    }

    if ($hasPassword) {
        Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'Password' -Value $Password;
    }

    if ([string]::IsNullOrWhiteSpace($ClientId)) {
        $ClientId = '51f81489-12ee-4a9e-aaae-a2591f45987d';
    }
    if ([string]::IsNullOrWhiteSpace($RedirectUri)) {
        $RedirectUri = 'http://localhost';
    }
    if ([string]::IsNullOrWhiteSpace($LoginPrompt)) {
        $LoginPrompt = 'Auto';
    }

    Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'AppId' -Value $ClientId;
    Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'RedirectUri' -Value $RedirectUri;
    Set-XrmConnectionStringValueInternal -Parameters $connectionStringParameters -Name 'LoginPrompt' -Value $LoginPrompt;

    return ConvertFrom-XrmConnectionStringMapInternal -Parameters $connectionStringParameters;
}