$files = Get-ChildItem -Path "c:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Ensure body has Times New Roman
        if ($content -match '<body[^>]*font-family') {
            # Already handled by previous script or exists
        } else {
            $content = $content -replace '<body', '<body style="font-family: ''Times New Roman'', Times, serif;"'
        }
        
        # Remove TailWind font classes that might override
        $content = $content -replace 'font-sans', ''
        $content = $content -replace 'font-display', ''
        $content = $content -replace 'font-heading', ''
        $content = $content -replace 'font-serif', ''

        [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
    }
}
