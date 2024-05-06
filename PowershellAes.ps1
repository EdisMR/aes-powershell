Clear-Host

Write-Host "##########################################"
Write-Host "##########################################"
Write-Host "##### Powershell Aes Encryption Tool #####"
Write-Host "##########################################"
Write-Host "##########################################"
Write-Host ""
Write-Host ""
Write-Host ""
<#
.SYNOPSIS
Encrypts a plain text using AES encryption algorithm.

.DESCRIPTION
This function encrypts a plain text using AES encryption algorithm. It takes as input
the plain text to be encrypted, the key and the IV (Initialization Vector) to use for
the encryption. The function returns the Base64 encoded string of the encrypted data.

.PARAMETER PlainText
The plain text to be encrypted.

.PARAMETER Key
The key to use for the encryption. The key must be 16, 24 or 32 bytes long.

.PARAMETER IV
The IV (Initialization Vector) to use for the encryption. The IV must be 16 bytes long.

.EXAMPLE
$encryptedText = Encrypt-String -PlainText "Hello World" -Key (1..16) -IV (1..16)

.OUTPUTS
The Base64 encoded string of the encrypted data.
#>
function Encrypt-String {
    param(
        [string]$PlainText,
        [byte[]]$Key,
        [byte[]]$IV
    )

    if ($null -eq $Key) {
        throw [System.ArgumentNullException]::new("Key cannot be null", "Key")
    }
    if ($null -eq $IV) {
        throw [System.ArgumentNullException]::new("IV cannot be null", "IV")
    }

    $aes = New-Object System.Security.Cryptography.AesCryptoServiceProvider
    try {
        # Set the key and IV for the algorithm.
        $aes.Key = $Key
        $aes.IV = $IV
    }
    catch [System.Security.Cryptography.CryptographicException] {
        # If key or IV are not 16, 24 or 32 bytes long, throw an exception.
        throw [System.ArgumentException]::new("Key and IV must be 16, 24 or 32 bytes", "Key")
    }

    $encryptor = $aes.CreateEncryptor($aes.Key, $aes.IV)

    $memoryStream = New-Object System.IO.MemoryStream
    $cryptoStream = New-Object System.Security.Cryptography.CryptoStream($memoryStream, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)

    try {
        # Convert the plain text to a byte array.
        $data = [System.Text.Encoding]::UTF8.GetBytes($PlainText)
    }
    catch [System.ArgumentNullException] {
        # If the plain text is null, throw an exception.
        throw [System.ArgumentNullException]::new("String to be encrypted cannot be null", "PlainText")
    }

    try {
        # Write the data to the crypto stream and flush it.
        $cryptoStream.Write($data, 0, $data.Length)
        $cryptoStream.FlushFinalBlock()
    }
    catch [System.ObjectDisposedException] {
        # If the crypto stream has been closed, throw an exception.
        throw [System.InvalidOperationException]::new("CipherStream has been closed", "CryptoStream")
    }
    catch [System.NullReferenceException] {
        # If the crypto stream is null, throw an exception.
        throw [System.NullReferenceException]::new("CipherStream cannot be null", "CryptoStream")
    }

    $encryptedData = $memoryStream.ToArray()

    $memoryStream.Dispose()
    $cryptoStream.Dispose()

    # Convert the encrypted data to a Base64 string.
    $encryptedString = [Convert]::ToBase64String($encryptedData)

    return $encryptedString
}


<#
.SYNOPSIS
Decrypts a Base64 encoded string using AES encryption algorithm.

.DESCRIPTION
This function decrypts a Base64 encoded string using AES encryption algorithm. It takes as input
the encrypted string, the key and the IV (Initialization Vector) to use for
the decryption. The function returns the decrypted plain text.

.PARAMETER EncryptedString
The Base64 encoded string to be decrypted.

.PARAMETER Key
The key to use for the decryption. The key must be 16, 24 or 32 bytes long.

.PARAMETER IV
The IV (Initialization Vector) to use for the decryption. The IV must be 16 bytes long.

.EXAMPLE
$decryptedText = Decrypt-String -EncryptedString "U2FsdGVkX1+l4mzXo86MgfUqWy9kRFtIQ5Pc8nR/eZs=" -Key (1..16) -IV (1..16)

.OUTPUTS
The decrypted plain text.
#>
function Decrypt-String {
    param(
        [string]$EncryptedString,
        [byte[]]$Key,
        [byte[]]$IV
    )

    if ($null -eq $Key) {
        throw [System.ArgumentNullException]::new("Key cannot be null", "Key")
    }
    if ($null -eq $IV) {
        throw [System.ArgumentNullException]::new("IV cannot be null", "IV")
    }

    $aes = New-Object System.Security.Cryptography.AesCryptoServiceProvider
    try {
        # Set the key and IV for the algorithm.
        $aes.Key = $Key
        $aes.IV = $IV
    }
    catch [System.Security.Cryptography.CryptographicException] {
        # If key or IV are not 16, 24 or 32 bytes long, throw an exception.
        throw [System.ArgumentException]::new("Key and IV must be 16, 24 or 32 bytes", "Key")
    }

    $decryptor = $aes.CreateDecryptor($aes.Key, $aes.IV)

    try {
        # Convert the Base64 encoded string to a byte array.
        $encryptedData = [Convert]::FromBase64String($EncryptedString)
    }
    catch [System.FormatException] {
        # If the Base64 encoded string is not valid, throw an exception.
        throw [System.FormatException]::new("Invalid Base64 string", "EncryptedString")
    }

    $memoryStream = New-Object System.IO.MemoryStream

    $cryptoStream = New-Object System.Security.Cryptography.CryptoStream($memoryStream, $decryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)

    $cryptoStream.Write($encryptedData, 0, $encryptedData.Length)
    $cryptoStream.FlushFinalBlock()

    $decryptedString = [System.Text.Encoding]::UTF8.GetString($memoryStream.ToArray())

    $cryptoStream.Close()
    $memoryStream.Close()

    return $decryptedString
}



$Key = Read-Host "Insert the password (must be 16, 24 or 32 bytes)"
$IV = Read-Host "Insert the IV (must be 16 bytes)"

$PlainText = Read-Host "Insert the string to be encrypted"

Clear-Host
Write-Host ""
Write-Host ""

try {
    $EncryptedString = Encrypt-String -PlainText $PlainText -Key ([System.Text.Encoding]::UTF8.GetBytes($Key)) -IV ([System.Text.Encoding]::UTF8.GetBytes($IV))
    Write-Host "Encrypted string: $EncryptedString"
}
catch {
    Write-Host "Error while encrypting the string: $($_.Exception.Message)"
}

Write-Host ""

try {
    $DecryptedString = Decrypt-String -EncryptedString $EncryptedString -Key ([System.Text.Encoding]::UTF8.GetBytes($Key)) -IV ([System.Text.Encoding]::UTF8.GetBytes($IV))
    Write-Host "Deciphered string: $DecryptedString"
}
catch {
    Write-Host "Error while deciphering the string: $($_.Exception.Message)"
}

Write-Host ""
Write-Host ""

<# pause script #>
Read-Host