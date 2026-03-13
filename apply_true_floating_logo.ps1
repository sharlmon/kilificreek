$files = Get-ChildItem -Path "C:\Users\Admin\OneDrive\Desktop\kilificreek" -Recurse -Filter "*.html" | Select-Object -ExpandProperty FullName

$newNavTemplate = @"
    <!-- Navbar -->
    <nav id="navbar" class="fixed w-full transition-transform duration-300 transform-gpu z-50 bg-[#1a1a1a]/95 backdrop-blur-md text-white shadow-2xl border-b border-white/5">
        <div class="container mx-auto px-4 md:px-12 lg:px-24 h-20 flex justify-between items-center relative">
            <!-- Floating Logo Badge -->
            <a href="{INDEX_PATH}index.html" class="absolute left-4 md:left-12 lg:left-24 top-1/2 z-50 transform -translate-y-1/2 hover:scale-105 transition-transform duration-300">
                <img class="h-20 md:h-32 w-auto object-contain drop-shadow-[0_10px_30px_rgba(0,0,0,0.6)]" src="{LOGO_PATH}static/images/logo/logo.png" alt="Kilifi Creek Festival Logo" />
            </a>

            <!-- Placeholder for logo space -->
            <div class="w-20 md:w-32"></div>

            <!-- Navigation Links -->
            <ul class="hidden md:flex items-center gap-1 uppercase text-xs lg:text-sm font-bold tracking-[0.2em]">
                <li><a href="{INDEX_PATH}index.html" class="px-4 py-3 hover:text-yellow-500 transition-colors">Home</a></li>
                <li><a href="{INDEX_PATH}about-us.html" class="px-4 py-3 hover:text-yellow-500 transition-colors">About Us</a></li>
                <li><a href="{INDEX_PATH}team.html" class="px-4 py-3 hover:text-yellow-500 transition-colors">Our Team</a></li>
                <li><a href="{INDEX_PATH}events.html" class="px-4 py-3 hover:text-yellow-500 transition-colors">Events</a></li>
                <li><a href="{INDEX_PATH}contact-us.html" class="px-4 py-3 hover:text-yellow-500 transition-colors">Contact</a></li>
                <li class="ml-6">
                    <a href="https://filmfreeway.com/KilifiCreekFestival" target="_blank"
                       class="inline-block px-8 py-2 bg-yellow-600 hover:bg-yellow-500 rounded-full text-white font-bold transition-all hover:shadow-[0_0_20px_rgba(202,138,4,0.4)]">🎬 Submit</a>
                </li>
            </ul>
         

            <!-- Mobile Menu Button -->
            <button id="menu-btn" class="md:hidden flex items-center text-white" aria-label="Open menu">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2"
                    stroke="currentColor" class="w-7 h-7">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16m-7 6h7" />
                </svg>
            </button>
        </div>
    </nav>
"@

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        $indexPath = ""
        $logoPath = "./"
        if ($file -match "rsvp" -or $file -match "events\\") {
            $indexPath = "../"
            $logoPath = "../"
        }
        
        $newNav = $newNavTemplate.Replace("{INDEX_PATH}", $indexPath).Replace("{LOGO_PATH}", $logoPath)
        
        # Replace the existing navbar
        $pattern = '(?s)<!-- Navbar -->.*?<nav id="navbar".*?</nav>'
        if ($content -match $pattern) {
            $content = [regex]::Replace($content, $pattern, $newNav)
            
            # Also fix emoji encoding just in case
            $content = $content -replace "ðŸŽ¬", "&#127916;"
            $content = $content -replace "🎬", "&#127916;"
            
            [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
            Write-Host "Updated navbar in $file"
        }
    }
}
