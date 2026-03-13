$files = Get-ChildItem -Path "c:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

$newHeader = @"
    <!-- Enhanced Professional Header & Integrated Banner -->
    <header class="fixed w-full transition-all duration-500 transform-gpu z-50 shadow-2xl">
        <!-- Main Navbar Ribbon (Increased Size) -->
        <nav id="navbar" class="w-full bg-black/95 backdrop-blur-2xl border-b border-white/5 h-20 flex items-center">
            <div class="container mx-auto h-full px-4 md:px-12 lg:px-24 flex items-center">
                
                <!-- Left Side Links -->
                <ul class="hidden md:flex flex-1 items-center justify-start gap-8 uppercase text-[11px] tracking-[0.3em] font-medium text-white/90">
                    <li><a href="{LOGO_PATH}index.html" class="hover:text-yellow-500 transition-colors duration-300">Home</a></li>
                    <li><a href="{LOGO_PATH}about-us.html" class="hover:text-yellow-500 transition-colors duration-300">About</a></li>
                    <li><a href="{LOGO_PATH}events.html" class="hover:text-yellow-500 transition-colors duration-300">Events</a></li>
                </ul>

                <!-- Centered Flush Logo (Integrated Perfectly) -->
                <div class="flex items-center justify-center px-6">
                    <a href="{LOGO_PATH}index.html" class="block transition-transform duration-300 hover:scale-110">
                        <img class="h-12 md:h-14 w-auto object-contain" src="{IMAGE_PATH}static/images/logo/logo.png" alt="Kilifi Creek Festival Logo" />
                    </a>
                </div>

                <!-- Right Side Links -->
                <ul class="hidden md:flex flex-1 items-center justify-end gap-8 uppercase text-[11px] tracking-[0.3em] font-medium text-white/90">
                    <li><a href="{LOGO_PATH}team.html" class="hover:text-yellow-500 transition-colors duration-300">Team</a></li>
                    <li><a href="{LOGO_PATH}contact-us.html" class="hover:text-yellow-500 transition-colors duration-300">Contact</a></li>
                    <li class="ml-4">
                        <a href="https://filmfreeway.com/KilifiCreekFestival" target="_blank"
                           class="inline-block px-5 py-2 border border-white/30 hover:bg-white hover:text-black rounded-full transition-all duration-300 text-[10px] font-bold tracking-widest uppercase">🎬 SUBMIT</a>
                    </li>
                </ul>

                <!-- Mobile Toggle -->
                <button id="menu-btn" class="md:hidden text-white/70 hover:text-white ml-auto transition-colors" aria-label="Open menu">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 9h16.5m-16.5 6.75h16.5" />
                    </svg>
                </button>
            </div>
        </nav>

        <!-- Professional Branded Banner (Constructed from Source Texture) -->
        <div class="w-full h-16 md:h-20 bg-[url('{IMAGE_PATH}home.jpg')] bg-cover bg-center border-t border-white/5 relative overflow-hidden">
            <div class="absolute inset-0 bg-black/70 backdrop-blur-md"></div>
            <div class="relative h-full flex flex-col items-center justify-center text-center px-4">
                <p class="text-white text-[9px] md:text-[10px] uppercase tracking-[0.4em] font-bold drop-shadow-[0_2px_4px_rgba(0,0,0,0.8)]">
                    23rd - 31st Oct 2026 | Kilifi Creek, Kenya
                </p>
                <h2 class="text-white text-xs md:text-sm lg:text-base font-bold tracking-[0.1em] mt-1.5 uppercase drop-shadow-[0_2px_4px_rgba(0,0,0,0.8)]">
                    Film Screenings in 7 Venues along the Kilifi Creek!
                </h2>
            </div>
        </div>
    </header>
"@

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        $logoPath = ""
        $imagePath = "./"
        if ($file -match "rsvp" -or $file -match "events\\") {
            $logoPath = "../"
            $imagePath = "../"
        }
        
        $tempHeader = $newHeader.Replace("{LOGO_PATH}", $logoPath).Replace("{IMAGE_PATH}", $imagePath)
        
        # Replace the entire header/nav block
        $patterns = @(
            '(?s)<!-- Enhanced Professional Header & Integrated Banner -->.*?<header.*?</header>',
            '(?s)<!-- Refined Slim Professional Navbar -->.*?<nav id="navbar".*?</nav>',
            '(?s)<!-- Expanded Professional Navbar -->.*?<nav id="navbar".*?</nav>',
            '(?s)<!-- Slim Professional Navbar -->.*?<nav id="navbar".*?</nav>',
            '(?s)<!-- Navbar -->.*?<nav id="navbar".*?</nav>'
        )
        
        $updated = $false
        foreach ($pattern in $patterns) {
            if ($content -match $pattern) {
                $content = [regex]::Replace($content, $pattern, $tempHeader)
                $updated = $true
                break
            }
        }
        
        # In index.html, remove the duplicated hero text box if it exists
        if ($file -match "index.html") {
            $heroBoxPattern = '(?s)<div class="relative z-10 md:mx-auto max-w-5xl.*?</div>'
            $content = $content -replace $heroBoxPattern, ""
            
            # Also adjust the hero padding to not hide under the dual header
            $content = $content -replace 'pt-16', 'pt-40'
        }
        
        if ($updated) {
            [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
            Write-Host "Updated header & banner in $file"
        }
    }
}
