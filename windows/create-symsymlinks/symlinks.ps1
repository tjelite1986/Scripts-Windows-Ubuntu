```powershell
# Function to create symbolic links
function Symlink-Items {
    param (
        [string]$ItemPath,
        [string]$Target,
        [string]$Cache
    )

    # Ensure that the target and cache directories exist
    if (-not (Test-Path $Target)) {
        New-Item -ItemType Directory -Path $Target -Force
    }
    if (-not (Test-Path $Cache)) {
        New-Item -ItemType Directory -Path $Cache -Force
    }

    # Get all items from the ItemPath
    $items = Get-ChildItem -Path $ItemPath -Recurse

    foreach ($item in $items) {
        $symlinkPath = Join-Path -Path $Cache -ChildPath $item.Name
        $targetPath = Join-Path -Path $Target -ChildPath $item.Name

        # Ensure that the target directory structure exists
        if ($item.PSIsContainer) {
            # Create directory in target if it does not exist
            if (-not (Test-Path $targetPath)) {
                New-Item -ItemType Directory -Path $targetPath -Force
            }
        }

        # Check if the symlink already exists
        if (-not (Test-Path $symlinkPath)) {
            # Create a symbolic link if the item is a file
            if (-not $item.PSIsContainer) {
                New-Item -ItemType SymbolicLink -Path $symlinkPath -Target $item.FullName
                Write-Host "Created symlink: $symlinkPath -> $item.FullName"

                # Copy the item to the target directory
                Copy-Item -Path $item.FullName -Destination $targetPath
                Write-Host "Copied to target: $targetPath"
            }
        } else {
            Write-Host "Symlink already exists: $symlinkPath"
        }
    }
}

# Define paths for Shows
$showsPath = "Z:\shows"
$targetPath = "P:\media\blackhole\sonarr"
$cachePath = "P:\media\blackhole\Cache"

# Call the function for shows
Symlink-Items -ItemPath $showsPath -Target $targetPath -Cache $cachePath
```
