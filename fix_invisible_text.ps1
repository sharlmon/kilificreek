$files = Get-ChildItem -Path "c:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Match text-white inside containers that are now bg-white
        # Special case for "Festival Team" h2
        $content = $content -replace 'text-2xl md:text-3xl lg:text-4xl mb-6 text-white', 'text-2xl md:text-3xl lg:text-4xl mb-6 text-gray-900'
        
        # Special case for "The Terrace Art Space" h3
        $content = $content -replace 'text-3xl font-bold text-white mb-8', 'text-3xl font-bold text-gray-900 mb-8'
        
        # General address info
        $content = $content -replace 'text-white font-medium', 'text-gray-900 font-bold'
        
        # Final cleanup for any text-white in sections that should be dark
        # Only if preceded by bg-white or within a container that we know is white
        # This is tricky, let's be specific to the blocks we saw.
        
        # "Our Base" span
        $content = $content -replace 'bg-yellow-500/10 border border-yellow-500/20 text-yellow-500', 'bg-yellow-100 border border-yellow-200 text-yellow-800'
        
        # FESTIVAL HEADQUARTERS title
        $content = $content -replace 'text-4xl md:text-5xl font-bold text-white tracking-tight', 'text-4xl md:text-5xl font-bold text-gray-900 tracking-tight'

        [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Fixed colors in $file"
    }
}
