$files = Get-ChildItem -Path "c:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Clean up remaining bg-black/50
        $content = $content -replace 'bg-black/50', 'bg-white'
        
        # Clean up literal newline artifacts '`n' that PowerShell injected natively
        $content = $content -replace '`n\s+<h3', '<h3'
        
        # In index.html, line 372 "text-white" on ul list
        $content = $content -replace '<ul class="mx-auto mt-12 grid max-w-md grid-cols-1 gap-10 sm:mt-16 lg:mt-20 lg:max-w-5xl lg:grid-cols-4 text-white">', '<ul class="mx-auto mt-12 grid max-w-md grid-cols-1 gap-10 sm:mt-16 lg:mt-20 lg:max-w-5xl lg:grid-cols-4 text-gray-900">'
        
        # Ensure hero title is black (not white) as user requested
        $content = $content -replace 'text-gray-900 text-center text-5xl md:text-5xl lg:text-7xl xl:text-7xl font-bold text-shadow-lg/30', 'text-gray-900 text-center text-5xl md:text-5xl lg:text-7xl xl:text-7xl font-bold'
        
        [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Cleaned $file"
    }
}
