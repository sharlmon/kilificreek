$files = Get-ChildItem -Path "c:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

$newNavbar = @"
    <!-- Antigravity Navbar -->
    <nav id="navbar" class="fixed w-full transition-transform duration-500 transform-gpu z-50 glass-ribbon h-20 flex items-center">
        <div class="container mx-auto px-4 flex justify-center items-center relative h-full">
            
            <!-- Antigravity Logo Field -->
            <div class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-[60%] flex items-center justify-center">
                <!-- Field Glow -->
                <div class="field-glow"></div>
                
                <!-- Floating Particles (Droplets & Leaves) -->
                <div class="floating-particle droplet" style="--dx: 40px; --dy: -60px; --duration: 5s; --delay: 0s; top: 0; left: 0;"></div>
                <div class="floating-particle droplet" style="--dx: -50px; --dy: -40px; --duration: 7s; --delay: 1s; top: 10px; left: -20px;"></div>
                <div class="floating-particle leaf-frag" style="--dx: 60px; --dy: -30px; --duration: 8s; --delay: 2s; top: -10px; left: 30px;"></div>
                <div class="floating-particle leaf-frag" style="--dx: -40px; --dy: -80px; --duration: 6s; --delay: 0.5s; top: 20px; left: -40px;"></div>

                <!-- Suspended Logo -->
                <a href="{LOGO_PATH}index.html" class="antigravity-logo block relative">
                    <div class="bg-white/95 p-3 rounded-2xl shadow-[0_20px_50px_rgba(0,0,0,0.4)] border border-white/20">
                        <img class="h-16 md:h-20 w-auto object-contain" src="{IMAGE_PATH}static/images/logo/logo.png" alt="Kilifi Creek Festival Logo" />
                    </div>
                </a>
            </div>

            <!-- Sleek Minimal Ribbon (Hidden labels as requested) -->
            <div class="flex-1"></div>
            <div class="hidden md:flex items-center gap-8 self-center">
                <ul class="nav-links flex gap-6 opacity-0 pointer-events-none transition-opacity duration-300">
                    <li><a href="{LOGO_PATH}index.html" class="text-xs uppercase tracking-widest text-white/60 hover:text-white">Home</a></li>
                    <li><a href="{LOGO_PATH}about-us.html" class="text-xs uppercase tracking-widest text-white/60 hover:text-white">About</a></li>
                    <li><a href="{LOGO_PATH}team.html" class="text-xs uppercase tracking-widest text-white/60 hover:text-white">Team</a></li>
                    <li><a href="{LOGO_PATH}events.html" class="text-xs uppercase tracking-widest text-white/60 hover:text-white">Events</a></li>
                    <li><a href="{LOGO_PATH}contact-us.html" class="text-xs uppercase tracking-widest text-white/60 hover:text-white">Contact</a></li>
                </ul>
            </div>

            <button id="menu-btn" class="md:hidden text-white/70 hover:text-white absolute right-4" aria-label="Open menu">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 9h16.5m-16.5 6.75h16.5" />
                </svg>
            </button>
        </div>
    </nav>
"@

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Determine relative paths
        $logoPath = ""
        $imagePath = "./"
        if ($file -match "rsvp" -or $file -match "events\\") {
            $logoPath = "../"
            $imagePath = "../"
        }
        
        $tempNav = $newNavbar.Replace("{LOGO_PATH}", $logoPath).Replace("{IMAGE_PATH}", $imagePath)
        
        # Replace the old navbar block
        $oldNavbarPattern = '(?s)<!-- Navbar -->.*?<nav id="navbar".*?</nav>'
        if ($content -match $oldNavbarPattern) {
            $content = [regex]::Replace($content, $oldNavbarPattern, $tempNav)
            [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
            Write-Host "Updated navbar in $file"
        }
    }
}
