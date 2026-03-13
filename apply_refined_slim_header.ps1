$files = Get-ChildItem -Path "c:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

$newNavbar = @"
    <!-- Refined Slim Professional Navbar -->
    <nav id="navbar" class="fixed w-full transition-all duration-500 transform-gpu z-50 bg-black/75 backdrop-blur-lg border-b border-white/5 h-12 flex items-center shadow-lg">
        <div class="container mx-auto h-full px-4 md:px-12 lg:px-24 flex items-center">
            
            <!-- Left Side Links -->
            <ul class="hidden md:flex flex-1 items-center justify-start gap-8 uppercase text-[10px] tracking-[0.25em] font-medium text-white/80">
                <li><a href="{LOGO_PATH}index.html" class="hover:text-yellow-500 transition-colors duration-300">Home</a></li>
                <li><a href="{LOGO_PATH}about-us.html" class="hover:text-yellow-500 transition-colors duration-300">About</a></li>
                <li><a href="{LOGO_PATH}events.html" class="hover:text-yellow-500 transition-colors duration-300">Events</a></li>
            </ul>

            <!-- Centered Flush Logo -->
            <div class="flex items-center justify-center px-4">
                <a href="{LOGO_PATH}index.html" class="block transition-transform duration-300 hover:scale-105">
                    <img class="h-7 w-auto object-contain" src="{IMAGE_PATH}static/images/logo/logo.png" alt="Kilifi Creek Festival Logo" />
                </a>
            </div>

            <!-- Right Side Links -->
            <ul class="hidden md:flex flex-1 items-center justify-end gap-8 uppercase text-[10px] tracking-[0.25em] font-medium text-white/80">
                <li><a href="{LOGO_PATH}team.html" class="hover:text-yellow-500 transition-colors duration-300">Team</a></li>
                <li><a href="{LOGO_PATH}contact-us.html" class="hover:text-yellow-500 transition-colors duration-300">Contact</a></li>
                <li class="ml-2">
                    <a href="https://filmfreeway.com/KilifiCreekFestival" target="_blank"
                       class="inline-block px-4 py-1 border border-white/20 hover:border-yellow-600 hover:bg-yellow-600 hover:text-white rounded-full transition-all duration-300 text-[9px] font-bold">🎬 SUBMIT</a>
                </li>
            </ul>

            <!-- Mobile Toggle -->
            <button id="menu-btn" class="md:hidden text-white/60 hover:text-white ml-auto transition-colors" aria-label="Open menu">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 9h16.5m-16.5 6.75h16.5" />
                </svg>
            </button>
        </div>
    </nav>
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
        
        $tempNav = $newNavbar.Replace("{LOGO_PATH}", $logoPath).Replace("{IMAGE_PATH}", $imagePath)
        
        # Replace the previous navbar block patterns
        $patterns = @(
            '(?s)<!-- Expanded Professional Navbar -->.*?<nav id="navbar".*?</nav>',
            '(?s)<!-- Slim Professional Navbar -->.*?<nav id="navbar".*?</nav>',
            '(?s)<!-- Navbar -->.*?<nav id="navbar".*?</nav>'
        )
        
        $updated = $false
        foreach ($pattern in $patterns) {
            if ($content -match $pattern) {
                $content = [regex]::Replace($content, $pattern, $tempNav)
                $updated = $true
                break
            }
        }
        
        if ($updated) {
            [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
            Write-Host "Updated navbar in $file"
        }
    }
}
