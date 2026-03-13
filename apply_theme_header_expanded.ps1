$files = Get-ChildItem -Path "c:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

$newNavbar = @"
    <!-- Expanded Professional Navbar -->
    <nav id="navbar" class="fixed w-full transition-all duration-500 transform-gpu z-50 bg-yellow-950/90 backdrop-blur-xl border-b border-yellow-500/20 h-20 flex items-center shadow-2xl">
        <div class="container mx-auto h-full px-4 md:px-12 lg:px-24 flex items-center">
            
            <!-- Left Side Links -->
            <ul class="hidden md:flex flex-1 items-center justify-start gap-8 uppercase text-xs tracking-[0.25em] font-bold text-white/90">
                <li><a href="{LOGO_PATH}index.html" class="hover:text-yellow-500 transition-all duration-300">Home</a></li>
                <li><a href="{LOGO_PATH}about-us.html" class="hover:text-yellow-500 transition-all duration-300">About</a></li>
                <li><a href="{LOGO_PATH}events.html" class="hover:text-yellow-500 transition-all duration-300">Events</a></li>
            </ul>

            <!-- Centered Flush Logo -->
            <div class="flex items-center justify-center">
                <a href="{LOGO_PATH}index.html" class="block transition-transform duration-500 hover:scale-110">
                    <img class="h-12 md:h-14 w-auto object-contain" src="{IMAGE_PATH}static/images/logo/logo.png" alt="Kilifi Creek Festival Logo" />
                </a>
            </div>

            <!-- Right Side Links -->
            <ul class="hidden md:flex flex-1 items-center justify-end gap-8 uppercase text-xs tracking-[0.25em] font-bold text-white/90">
                <li><a href="{LOGO_PATH}team.html" class="hover:text-yellow-500 transition-all duration-300">Team</a></li>
                <li><a href="{LOGO_PATH}contact-us.html" class="hover:text-yellow-500 transition-all duration-300">Contact</a></li>
                <li class="ml-4">
                    <a href="https://filmfreeway.com/KilifiCreekFestival" target="_blank"
                       class="inline-block px-5 py-2 bg-yellow-600 hover:bg-yellow-500 text-white rounded-full transition-all duration-300 text-[10px] font-bold tracking-widest shadow-lg shadow-yellow-900/20">🎬 SUBMIT</a>
                </li>
            </ul>

            <!-- Mobile Toggle -->
            <button id="menu-btn" class="md:hidden text-white/90 hover:text-yellow-500 ml-auto transition-colors" aria-label="Open menu">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6">
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
        
        # Replace the professional navbar block (the one I just put in)
        $oldNavbarPattern = '(?s)<!-- Slim Professional Navbar -->.*?<nav id="navbar".*?</nav>'
        if ($content -match $oldNavbarPattern) {
            $content = [regex]::Replace($content, $oldNavbarPattern, $tempNav)
        } else {
            # Check for generic navbar pattern if the previous replacement failed or if it was different
            $oldNavbarPattern2 = '(?s)<!-- Navbar -->.*?<nav id="navbar".*?</nav>'
            if ($content -match $oldNavbarPattern2) {
                $content = [regex]::Replace($content, $oldNavbarPattern2, $tempNav)
            }
        }
        
        # Also clean up the previous design script mentioned in comments if necessary
        # Just write the updated content
        [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Updated navbar in $file"
    }
}
