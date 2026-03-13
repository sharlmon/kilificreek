$files = Get-ChildItem -Path "c:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

foreach ($file in $files) {
    $content = Get-Content $file -Raw -Encoding UTF8
    
    # 1. Update Body tag to be solid white with dark text
    $content = $content -replace '<body class="antialiased min-h-screen" style="font-family: ''Times New Roman'', Times, serif; color: #ffffff; background-color: #000000;.*?>', '<body class="antialiased min-h-screen bg-white text-gray-900" style="font-family: ''Times New Roman'', Times, serif;">'

    # 2. General Global Text Color Updates (switching white text targeting to dark)
    # Be careful not to replace text-white in the navbar! Let's only target specific blocks.
    # Actually, the entire body is white. We need to handle text colors in sections.
    # Turn text-white into text-gray-900 ONLY outside of nav and footer.
    # A safer way: apply specific regex patches.
    
    # Global containers: remove border-white/10 and bg-black/50, replace with bg-white, shadow-xl, grey text.
    $content = $content -replace 'bg-black/50\s+border\s+border-white/10', 'bg-white text-gray-900 shadow-2xl'
    $content = $content -replace 'bg-black/50\s+border\s+border-transparent', 'bg-white text-gray-900 shadow-2xl'
    $content = $content -replace 'bg-black/40', 'bg-white text-gray-900 shadow-md border border-gray-100'
    $content = $content -replace 'border-white/10', 'border-gray-100'
    $content = $content -replace 'border-white/5', 'border-gray-100'

    # Dark text replacements
    $content = $content -replace 'text-gray-100', 'text-gray-700'
    $content = $content -replace 'text-gray-200', 'text-gray-600'
    $content = $content -replace 'text-gray-300', 'text-gray-600'
    $content = $content -replace 'text-gray-400', 'text-gray-500'

    # Remove ALL blur classes
    $content = $content -replace 'backdrop-blur-\[10px\]', ''
    $content = $content -replace 'backdrop-blur-xl', ''
    $content = $content -replace 'backdrop-blur-md', ''
    $content = $content -replace 'backdrop-filter:\s*blur\([^)]+\)', ''
    
    # Text-shadow edits (remove heavy dark shadows from dark text)
    $content = $content -replace 'text-shadow-lg/30', ''
    $content = $content -replace 'text-shadow-2xl', ''
    $content = $content -replace 'text-shadow-lg', ''
    $content = $content -replace 'text-shadow-md/20', ''
    
    # White text color replacements outside navbar
    # To avoid hitting navbar, let's explicitly target the section classes
    $content = $content -replace '<h1 class="text-white', '<h1 class="text-gray-900'
    $content = $content -replace '<h2 class="text-white', '<h2 class="text-gray-900'
    $content = $content -replace 'text-white text-center fluid-heading-primary', 'text-gray-900 text-center fluid-heading-primary'
    $content = $content -replace 'text-white text-right fluid-heading-secondary', 'text-gray-900 text-right fluid-heading-secondary'
    
    # Hero Title section (Needs bg-white box)
    $content = $content -replace 'class="grid border border-gray-100 py-12 px-6 bg-white text-gray-900 shadow-2xl rounded-3xl mx-4 my-8 shadow-2xl md:mx-auto max-w-5xl\s*"', 'class="grid border border-gray-200 py-16 px-10 bg-white text-gray-900 rounded-3xl mx-4 my-8 shadow-2xl md:mx-auto max-w-5xl"'
    
    if ($file -match "index\.html") {
        # The hero section div needs the background image added to it since it was removed from body
        $content = $content -replace '<div class="relative w-screen h-screen bg-transparent text-center grid grid-flow-row pt-16 items-center">', '<div class="relative w-screen h-screen bg-[url(''./home.jpg'')] bg-cover bg-center bg-fixed text-center grid grid-flow-row pt-16 items-center">'
        
        # White boxes for text. 'A Symphony of Stories' container:
        $content = $content -replace '<div class="p-12 md:p-24 flex justify-start items-center text-white">', '<div class="p-12 md:p-24 flex justify-start items-center text-gray-900">'
        
        # Fix the 2026 Theme Text Box
        # We need to wrap the text in a white box inside the image breakout section
        $content = $content -replace '<div class="relative z-10 text-center py-24 md:py-24">', '<div class="relative z-10 text-center py-24 md:py-24"><div class="bg-white max-w-4xl mx-auto rounded-3xl p-12 shadow-2xl">'
        # Closing div before the end of the section
        $content = $content -replace 'Revive, Reconnect, and Regenerate\.</h2>\s*</div>', "Revive, Reconnect, and Regenerate.</h2>`n            </div>`n        </div>"

        # Theme 2026 Text colors to dark
        $content = $content -replace '<h1 class="text-gray-900 text-center text-3xl  md:text-4xl lg:text-5xl xl:text-6xl font-display font-bold mb-6"', '<h1 class="text-gray-900 text-center text-3xl md:text-4xl lg:text-5xl xl:text-6xl font-display font-bold mb-6"'
        $content = $content -replace '<h2 class="font-display font-bold text-white text-3xl md:text-5xl lg:text-5xl mb-6 uppercase"', '<h2 class="font-display font-bold text-gray-900 text-3xl md:text-5xl lg:text-5xl mb-6 uppercase"'
        $content = $content -replace '<h2 class="font-display font-bold text-white  text-3xl md:text-5xl lg:text-5xl mb-6"', '<h2 class="font-display font-bold text-gray-900 text-3xl md:text-5xl lg:text-5xl mb-6"'
        
        # Fix events list hardcoded text colors 
        $content = $content -replace 'color: white !important;', 'color: #1a1a1a !important;'
        $content = $content -replace 'bg-yellow-800/60 text-white', 'bg-yellow-100 text-yellow-900'
        $content = $content -replace '<div class="ml-6 lg:ml-0 lg:mt-10">\s*<h3\s*class="text-xl font-bold text-white', '<div class="ml-6 lg:ml-0 lg:mt-10">`n                        <h3 class="text-xl font-bold text-gray-900'
        
        # Heading for "Our Community of Creators" needs dark text
        $content = $content -replace '<h2 class="font-poppins text-\[28px\] shrink-0 font-bold text-white mb-2">', '<h2 class="font-poppins text-[28px] shrink-0 font-bold text-gray-900 mb-2">'
        $content = $content -replace 'text-yellow-100 text-sm tracking-widest uppercase font-light', 'text-yellow-800 text-sm tracking-widest uppercase font-bold'
        
        # Heading for "Last year's program"
        $content = $content -replace '<h2 class="mt-6 text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl lg:text-5xl"><a href="\./events/kilifi-creek-2026\.html" style="color: #1a1a1a !important;">', '<h2 class="mt-6 text-3xl font-bold tracking-tight sm:text-4xl lg:text-5xl"><a href="./events/kilifi-creek-2026.html" style="color: #1a1a1a !important;">'
    }

    if ($file -match "about-us\.html") {
        $content = $content -replace '<div class="container mx-auto py-12 px-8 sm:px-12 lg:px-16 rounded-3xl border border-gray-100 shadow-2xl transition-all duration-500">', '<div class="container mx-auto py-24 px-8 sm:px-12 lg:px-16 bg-white rounded-3xl shadow-xl transition-all duration-500">'
        $content = $content -replace '<h2 class="text-4xl font-bold text-gray-900 mb-8', '<h2 class="text-4xl font-bold text-gray-900 mb-8'
        $content = $content -replace '<div class="flex justify-center text-4xl font-bold text-gray-900', '<div class="flex justify-center text-4xl font-bold text-gray-900'
        # Ensure the visit our location text is dark
        $content = $content -replace '<div class="bg-gray-700 p-0 md:p-0 flex justify-start text-white">', '<div class="bg-white text-gray-900 p-0 md:p-0 flex justify-start">'
    }
    
    # RSVP Forms updates
    if ($file -match "rsvp-") {
        # Make sure main form container uses a white box instead of dark inline styling
        $content = $content -replace '<div class="w-full px-4 sm:px-10 py-10">', '<div class="w-full px-4 sm:px-10 py-20 bg-white text-gray-900">'
        $content = $content -replace 'bg-gray-100 p-8 rounded', 'bg-white p-8 rounded-3xl shadow-xl border border-gray-100'
        # The hero section needs the bg image restored since body string match removes it
        # Actually RSVP hero has `<div class="relative w-screen h-80 bg-[url...` which remains intact!
        $content = $content -replace '<aside class="">', '<aside class="text-gray-900">'
    }

    [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
    Write-Host "Processed $file"
}
