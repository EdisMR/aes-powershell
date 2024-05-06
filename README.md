# PowerShell AES Encryption / Decryption Tool

This PowerShell script provides functionalities to encrypt and decrypt text using the AES encryption algorithm.

## Usage

1. Run the script in PowerShell.
2. Follow the instructions to input the password (which must be 16, 24, or 32 bytes) and the IV (must be 16 bytes).
3. Input the text you want to encrypt or decrypt when prompted.

## Available Functions

### `Encrypt-String`

This function encrypts plain text using the AES encryption algorithm.

#### Parameters

- **PlainText**: The plain text to be encrypted.
- **Key**: The key for encryption. It must be 16, 24, or 32 bytes long.
- **IV**: The Initialization Vector (IV) for encryption. It must be 16 bytes long.

### `Decrypt-String`

This function decrypts a Base64 encoded string using the AES encryption algorithm.

#### Parameters

- **EncryptedString**: The Base64 encoded string to be decrypted.
- **Key**: The key for decryption. It must be 16, 24, or 32 bytes long.
- **IV**: The Initialization Vector (IV) for decryption. It must be 16 bytes long.

## Example

```powershell
$encryptedText = Encrypt-String -PlainText "Hello World" -Key (1..16) -IV (1..16)
$decryptedText = Decrypt-String -EncryptedString $encryptedText -Key (1..16) -IV (1..16)
```

## Author

Both scripts where developed by EdisMR (edisanthony@gmail.com).
