$files = Get-ChildItem -Path "c:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Use regex capture group for the logo source path
        $logoPattern = '(<div class="bg-white rounded-b-3xl shadow-\[0_8px_30px_rgb\(0,0,0,0\.4\)\] border-x border-b border-gray-100 flex items-center justify-center"[^>]*>.*?<img class="h-12 w-auto py-2 object-contain" src=")([^"]+)(" alt="Kilifi Creek Festival Logo" />.*?</div>)'
        
        $newLogoReplacement = {
            param($match)
            $src = $match.Groups[2].Value
            return @"
<div class="bg-white p-2 rounded-b-3xl shadow-[0_8px_30px_rgb(0,0,0,0.4)] border-x border-b border-gray-100 flex items-center justify-center" 
                     style="filter: drop-shadow(0px 4px 15px rgba(0,0,0,0.4));">
                    <img class="h-16 md:h-24 w-auto object-contain" src="$src" alt="Kilifi Creek Festival Logo" />
                </div>
"@
        }

        $content = [regex]::Replace($content, $logoPattern, $newLogoReplacement, [System.Text.RegularExpressions.RegexOptions]::Singleline)

        # 2. Update Fonts to Times New Roman
        # Replace fontFamily block in tailwind.config
        $content = [regex]::Replace($content, 'fontFamily:\s*\{[^}]+\}', 'fontFamily: { display: [''"Times New Roman"'', ''serif''], heading: [''"Times New Roman"'', ''serif''], body: [''"Times New Roman"'', ''serif''] }')
        
        # Replace inline styles for font-family
        $content = [regex]::Replace($content, 'font-family:\s*''[^'']+''\s*,\s*[^;''"]+', 'font-family: ''Times New Roman'', Times, serif')
        $content = [regex]::Replace($content, 'font-family:\s*"[^"]+"\s*,\s*[^;''"]+', 'font-family: "Times New Roman", Times, serif')
        $content = [regex]::Replace($content, 'font-family:\s*''SNOWMAS''\s*,\s*serif', 'font-family: ''Times New Roman'', Times, serif')

        # Fix specific cases missed by regex
        $content = $content -replace 'font-family: ''Playtime With Hot Toddies'', sans-serif;', 'font-family: ''Times New Roman'', Times, serif;'
        $content = $content -replace 'font-family: "Playtime With Hot Toddies", sans-serif;', 'font-family: "Times New Roman", Times, serif;'
        $content = $content -replace 'style="font-family: ''SNOWMAS'', sans-serif;"', 'style="font-family: ''Times New Roman'', Times, serif;"'

        [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Updated fonts and logo in $file"
    }
}
