
$CryptoHashAlgorythm = "SHA1";
$CryptoInitVector = "ahC3@bCa2Didfc3d";
$CryptoKeySize = 256;
$CryptoPassPhrase = "MsCrmTools";
$CryptoPasswordIterations = 2;
$CryptoSaltValue = "Tanguy 92*";

function Repair-XrbConnectionString {
    PARAM(
        [Parameter(Mandatory = $True)]
        [string]
        [ValidateNotNullOrEmpty()]
        $ConnectionString
    )

    $ConnectionStringBackup = $ConnectionString;
    $potentialEncryptedParameters = @("Password", "ClientSecret");
    $isDecrypted = $false;
    foreach ($parameter in $potentialEncryptedParameters) {        
        if($isDecrypted){
            continue;
        }

        $encryptedText = $ConnectionString | Out-XrmConnectionStringParameter -ParameterName $parameter;
        if ([String]::IsNullOrWhiteSpace($encryptedText)) {
            continue;
        }

        # Weird case : remove "..." added by XTB
        if($encryptedText.StartsWith('"') -and $encryptedText.EndsWith('"'))
        {
            $encryptedText = $encryptedText.TrimStart('"');
            $encryptedText = $encryptedText.TrimEnd('"');
        }

        $clearText = Unprotect-XrmToolBoxPassword -EncryptedPassword $encryptedText;
        $ConnectionString = $ConnectionString.Replace($encryptedText, $clearText);
        $isDecrypted = $true;
    }

    if ($ConnectionStringBackup -eq $ConnectionString) {
        throw "ConnectionString is not encrypted!";
    }
    return $ConnectionString;
}

function Protect-XrmToolBoxPassword {
    PARAM(
        [Parameter(Mandatory = $True)]
        [string]
        [ValidateNotNullOrEmpty()]
        $Password
    )

    $initVectorBytes = [System.Text.Encoding]::ASCII.GetBytes($CryptoInitVector);
    $saltValueBytes = [System.Text.Encoding]::ASCII.GetBytes($CryptoSaltValue);
    $plainTextBytes = [System.Text.Encoding]::UTF8.GetBytes($Password);

    $passwordBytes = new-object "System.Security.Cryptography.PasswordDeriveBytes" -ArgumentList $CryptoPassPhrase, $saltValueBytes, $CryptoHashAlgorythm, $CryptoPasswordIterations;
    $keyBytes = $passwordBytes.GetBytes($CryptoKeySize / 8);

    $symmetricKey = new-object "System.Security.Cryptography.RijndaelManaged";
    $symmetricKey.Mode = [System.Security.Cryptography.CipherMode]::CBC;
    $encryptor = $symmetricKey.CreateEncryptor($keyBytes, $initVectorBytes);

    $memoryStream = new-object "System.IO.MemoryStream";
    $cryptoStreamMode = [System.Security.Cryptography.CryptoStreamMode]::Write;
    $cryptoStream = new-object "System.Security.Cryptography.CryptoStream" -ArgumentList $memoryStream, $encryptor, $cryptoStreamMode;
    $cryptoStream.Write($plainTextBytes, 0, $plainTextBytes.Length);
    $cryptoStream.FlushFinalBlock() | Out-Null;

    $cipherTextBytes = $memoryStream.ToArray();

    $memoryStream.Close() | Out-Null;
    $cryptoStream.Close() | Out-Null;

    $cipherText = [Convert]::ToBase64String($cipherTextBytes);

    return $cipherText;
}

function Unprotect-XrmToolBoxPassword {
    PARAM(
        [Parameter(Mandatory = $True)]
        [string]
        [ValidateNotNullOrEmpty()]
        $EncryptedPassword
    )

    $initVectorBytes = [System.Text.Encoding]::ASCII.GetBytes($CryptoInitVector);
    $saltValueBytes = [System.Text.Encoding]::ASCII.GetBytes($CryptoSaltValue);
    $cipherBytes = [Convert]::FromBase64String($EncryptedPassword);
    $passwordBytes = new-object "System.Security.Cryptography.PasswordDeriveBytes" -ArgumentList $CryptoPassPhrase, $saltValueBytes, $CryptoHashAlgorythm, $CryptoPasswordIterations;
    $keyBytes = $passwordBytes.GetBytes($CryptoKeySize / 8);
    
    $symmetricKey = new-object "System.Security.Cryptography.RijndaelManaged";
    $symmetricKey.Mode = [System.Security.Cryptography.CipherMode]::CBC;
    $decryptor = $symmetricKey.CreateDecryptor($keyBytes, $initVectorBytes);

    $memoryStream = new-object "System.IO.MemoryStream" -ArgumentList (, $cipherBytes);
    $cryptoStreamMode = [System.Security.Cryptography.CryptoStreamMode]::Read;
    $cryptoStream = new-object "System.Security.Cryptography.CryptoStream" -ArgumentList $memoryStream, $decryptor, $cryptoStreamMode;
    
    $decryptedBytes = New-Object "System.Byte[]" -ArgumentList $cipherBytes.Length;
    $decryptedBytesLength = $cryptoStream.Read($decryptedBytes, 0, $decryptedBytes.Length);
    
    $memoryStream.Close() | Out-Null;
    $cryptoStream.Close() | Out-Null;

    $cipherText = [System.Text.Encoding]::UTF8.GetString($decryptedBytes, 0, $decryptedBytesLength);

    return $cipherText;
}