Clear-Host
Write-Host "##########################################"
Write-Host "##########################################"
Write-Host "##### Powershell AES Decryption Tool ####"
Write-Host "##### EDISMR - edisanthony@gmail.com #####"
Write-Host "##########################################"
Write-Host "##########################################"
Write-Host ""
Write-Host ""
Write-Host ""

<# Definición de la función Decrypt-String #>
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

<# Solicitar al usuario la cadena encriptada, la clave y el IV #>
$EncryptedString = Read-Host "Insert the encrypted string"
Write-Host ""
$Key = Read-Host "Insert the password (must be 16, 24 or 32 bytes)"
Write-Host ""
$IV = Read-Host "Insert the IV (must be 16 bytes independent of the password length)"
Write-Host ""

Clear-Host
Write-Host "##########################################"
Write-Host "##########################################"
Write-Host "##### Powershell AES Decryption Tool ####"
Write-Host "##### EDISMR - edisanthony@gmail.com #####"
Write-Host "##########################################"
Write-Host "##########################################"
Write-Host ""
Write-Host ""
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
Write-Host ""

<# Pause the script #>
Read-Host
