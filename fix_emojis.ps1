$files = Get-ChildItem -Path "C:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Globally replace common problematic emojis
        $content = $content -replace "ðŸŽ¬", "&#127916;"
        $content = $content -replace "🎬", "&#127916;"
        
        [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Fixed emojis in $file"
    }
}
