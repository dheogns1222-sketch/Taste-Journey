# Taste Journey - Git Setup Script (Clean Install)

$ErrorActionPreference = "Continue"
$folder = "D:\Clode\Projects\Taste Journey"
$remote = "https://github.com/dheogns1222-sketch/Taste-Journey.git"

Set-Location $folder

Write-Host ""
Write-Host "========================================"
Write-Host "  Taste Journey Git Setup"
Write-Host "========================================"
Write-Host ""

# STEP 1: Remove broken .git folder
Write-Host "[STEP 1] Removing broken .git folder..."
if (Test-Path ".git") {
    Remove-Item -Path ".git" -Recurse -Force
    Write-Host "  Done: .git folder removed"
} else {
    Write-Host "  No .git folder found, skipping"
}
Write-Host ""

# STEP 2: Clone into temp, steal the .git folder
Write-Host "[STEP 2] Connecting to GitHub repo..."
$temp = "$env:TEMP\taste-journey-temp"
if (Test-Path $temp) { Remove-Item $temp -Recurse -Force }
git clone $remote $temp
Move-Item "$temp\.git" "$folder\.git"
Remove-Item $temp -Recurse -Force
Write-Host "  Done: GitHub repo connected"
Write-Host ""

# STEP 3: Rename master to main
Write-Host "[STEP 3] Renaming master to main..."
git branch -m master main
git push origin main
git push origin --delete master
Write-Host "  Done."
Write-Host ""

# STEP 4: Commit new files
Write-Host "[STEP 4] Committing new files..."
git add README.md CHANGELOG.md
git commit -m "docs: README and CHANGELOG initial setup"
Write-Host "  Commit 1 done: docs"

git add .gitignore src public docs .github
git commit -m "chore: project structure and gitignore setup"
Write-Host "  Commit 2 done: chore"
Write-Host ""

# STEP 5: Push main
Write-Host "[STEP 5] Pushing main..."
git push -u origin main
Write-Host "  Done."
Write-Host ""

# STEP 6: Create develop branch
Write-Host "[STEP 6] Creating develop branch..."
git checkout -b develop
git push -u origin develop
Write-Host "  Done."
Write-Host ""

# Summary
Write-Host "========================================"
Write-Host "  Setup Complete!"
Write-Host "========================================"
Write-Host ""
Write-Host "Branch status:"
git branch -a
Write-Host ""
Write-Host "Recent commits:"
git log --oneline -5
Write-Host ""
Write-Host "Files:"
Get-ChildItem -Recurse -Name | Where-Object { $_ -notmatch "\.git" }
Write-Host ""
Write-Host "GitHub: https://github.com/dheogns1222-sketch/Taste-Journey"
