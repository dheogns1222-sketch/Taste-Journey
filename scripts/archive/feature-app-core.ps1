# Taste Journey - feature/app-core branch + commit script

$ErrorActionPreference = "Stop"
$folder = "D:\Clode\Projects\Taste Journey"
Set-Location $folder

Write-Host ""
Write-Host "========================================"
Write-Host "  Taste Journey - App Core Feature Branch"
Write-Host "========================================"
Write-Host ""

# STEP 1: Make sure we are on develop
Write-Host "[STEP 1] Switching to develop..."
git checkout develop
git pull origin develop
Write-Host "  Done."
Write-Host ""

# STEP 2: Create feature branch
Write-Host "[STEP 2] Creating feature/app-core..."
git checkout -b feature/app-core
Write-Host "  Done."
Write-Host ""

# STEP 3: Commit the PWA app
Write-Host "[STEP 3] Committing src/index.html..."
git add src/index.html

git commit -m "feat: single-file PWA app core (index.html)

- Canvas-based OSM tile map (no external libraries)
- Red pin (visited) / Blue pin (wishlist) markers
- Categories: 한식/일식/중식/양식/카페/술집/고기/기타
- 10-point rating system + revisit flag
- Nominatim address search with debounce
- Wishlist + priority ordering
- LocalStorage auth + RBAC: OWNER/PARTNER/GUEST
- Visibility levels: 전체/회원/커플/관리자
- Comments/replies/likes community system
- Statistics + taste analysis + insight
- Share card PNG (1:1, 4:5, 16:9 Canvas generation)
- JSON export/import with merge dedup
- Auto-save draft + tab-leave confirmation
- Premium Wood theme (#6B4226/#C48A4A/#F6F1EB)
- Auto dark mode via prefers-color-scheme
- PWA manifest (data URI) + Service Worker (Blob URL)
- Zero external fonts/CSS/JS - fully inline"

Write-Host "  Commit done."
Write-Host ""

# STEP 4: Push feature branch
Write-Host "[STEP 4] Pushing feature/app-core to GitHub..."
git push -u origin feature/app-core
Write-Host "  Done."
Write-Host ""

# Summary
Write-Host "========================================"
Write-Host "  Branch pushed!"
Write-Host "========================================"
Write-Host ""
Write-Host "Branch graph:"
git log --oneline --graph --all -10
Write-Host ""
Write-Host "Next: Create PR on GitHub"
Write-Host "  feature/app-core --> develop"
Write-Host ""
Write-Host "URL: https://github.com/dheogns1222-sketch/Taste-Journey/compare/develop...feature/app-core"
