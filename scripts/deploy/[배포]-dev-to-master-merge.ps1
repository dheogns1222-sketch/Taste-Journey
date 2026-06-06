# ================================================================
# Taste Journey — [배포] dev → master 머지 & 라이브 배포
# dev 브랜치 테스트 완료 후 실행
# 실행: 이 파일 우클릭 → "PowerShell로 실행"
# ================================================================

$ROOT = "D:\Clode\Projects\Taste Journey"
Set-Location $ROOT

function Info  { param($m) Write-Host $m -ForegroundColor Cyan }
function Ok    { param($m) Write-Host $m -ForegroundColor Green }
function Warn  { param($m) Write-Host $m -ForegroundColor Yellow }
function Fail  { param($m) Write-Host $m -ForegroundColor Red }

Info "=========================================="
Info "  Taste Journey  |  [배포] dev → master 머지"
Info "=========================================="

$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force; Warn "index.lock 제거" }

# dev 브랜치 최신 상태 확인
$current = (git rev-parse --abbrev-ref HEAD 2>&1)
Info "현재 브랜치: $current"

# dev 변경사항 저장 (있을 경우)
$status = git status --short
if ($status) {
    Warn "`n저장되지 않은 변경사항이 있습니다:"
    git status --short
    $save = Read-Host "`ndev에 커밋하고 진행할까요? (y/n)"
    if ($save -eq 'y') {
        $msg = Read-Host "커밋 메시지"
        if (-not $msg.Trim()) { $msg = "chore: 머지 전 정리" }
        if ($current -ne "dev") { git checkout dev }
        git add src/index.html docs/index.html
        git commit -m $msg
        git push origin dev
    } else {
        Fail "변경사항 처리 후 다시 실행하세요."
        Read-Host; exit 1
    }
}

# master로 전환 후 머지
Info "`nmaster 브랜치로 전환..."
git checkout master
if ($LASTEXITCODE -ne 0) { Fail "master 전환 실패"; Read-Host; exit 1 }

Info "dev → master 머지..."
git merge dev --no-ff -m "merge: dev → master (라이브 배포)"
if ($LASTEXITCODE -ne 0) {
    Fail "머지 충돌 발생. 충돌을 해결한 후 수동으로 커밋하세요."
    Read-Host; exit 1
}

# docs/ 동기화 (src → docs 복사)
Info "docs/ 동기화..."
Copy-Item "src\index.html" "docs\index.html" -Force
git add docs/index.html
$hasChanges = git diff --cached --quiet; if ($LASTEXITCODE -ne 0) {
    git commit -m "sync: docs/ 동기화"
}

# 푸시
Info "master 푸시..."
git push origin master

if ($LASTEXITCODE -eq 0) {
    Ok "`n=========================================="
    Ok "  배포 완료!"
    Ok "  Netlify: https://prismatic-marzipan-0081c6.netlify.app"
    Ok "  (1~2분 후 반영됩니다)"
    Ok "=========================================="
} else {
    Fail "푸시 실패."
}

Read-Host "`n엔터를 누르면 창이 닫힙니다"
