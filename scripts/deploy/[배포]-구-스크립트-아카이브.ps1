# ================================================================
# Taste Journey — 루트의 기존 PS1 파일들을 scripts/archive/ 로 이동
# 처음 한 번만 실행하세요
# 실행: 이 파일 우클릭 → "PowerShell로 실행"
# ================================================================

$ROOT = "D:\Clode\Projects\Taste Journey"
Set-Location $ROOT

function Info  { param($m) Write-Host $m -ForegroundColor Cyan }
function Ok    { param($m) Write-Host $m -ForegroundColor Green }
function Warn  { param($m) Write-Host $m -ForegroundColor Yellow }

Info "=========================================="
Info "  기존 PS1 파일 → scripts/archive/ 이동"
Info "=========================================="

$archiveDir = "scripts\archive"
if (-not (Test-Path $archiveDir)) { New-Item -ItemType Directory -Path $archiveDir | Out-Null }

$files = @(
    "2026-06-06-deploy-github-pages.ps1",
    "2026-06-06-deploy-with-firebase-sync.ps1",
    "2026-06-06-git-commit-all-features.ps1",
    "2026-06-06-git-commit-avatar-role.ps1",
    "2026-06-06-git-commit-bugfix.ps1",
    "2026-06-07-deploy-auth-overhaul.ps1",
    "2026-06-07-deploy-final.ps1",
    "2026-06-07-deploy-fix-truncation.ps1",
    "2026-06-07-deploy-kakao-search.ps1",
    "2026-06-07-deploy-kakao-ui-overhaul.ps1",
    "feature-app-core.ps1",
    "setup-git.ps1"
)

foreach ($f in $files) {
    if (Test-Path $f) {
        Move-Item $f "$archiveDir\$f" -Force
        Ok "이동: $f"
    } else {
        Warn "없음 (건너뜀): $f"
    }
}

Ok "`n완료! 기존 스크립트들이 scripts\archive\ 로 이동되었습니다."
Info "앞으로는 scripts\deploy\ 와 scripts\dev\ 폴더의 스크립트를 사용하세요."

Read-Host "`n엔터를 누르면 창이 닫힙니다"
