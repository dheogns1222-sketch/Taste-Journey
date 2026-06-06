# ================================================================
# Taste Journey — [데브] dev 브랜치 최초 1회 초기 설정
# 처음 한 번만 실행하세요
# 실행: 이 파일 우클릭 → "PowerShell로 실행"
# ================================================================

$ROOT = "D:\Clode\Projects\Taste Journey"
Set-Location $ROOT

function Info  { param($m) Write-Host $m -ForegroundColor Cyan }
function Ok    { param($m) Write-Host $m -ForegroundColor Green }
function Warn  { param($m) Write-Host $m -ForegroundColor Yellow }
function Fail  { param($m) Write-Host $m -ForegroundColor Red }

Info "=========================================="
Info "  Taste Journey  |  [데브] 초기 설정"
Info "=========================================="

$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force }

# 1. 현재 상태를 master에 먼저 커밋
Info "`n[1/5] 현재 변경사항 master에 커밋..."
$status = git status --short
if ($status) {
    git add src/index.html docs/index.html
    git commit -m "deploy: 15개 버그 수정 (회원가입/권한/UI/Firebase 연동 등)"
    git push origin master
    if ($LASTEXITCODE -eq 0) { Ok "master 커밋 완료" } else { Warn "master 푸시 실패 (계속 진행)" }
} else {
    Ok "변경사항 없음"
}

# 2. dev 브랜치 생성 (master에서 분기)
Info "`n[2/5] dev 브랜치 생성..."
$devExists = git show-ref --verify --quiet refs/heads/dev; $devOk = $LASTEXITCODE
if ($devOk -eq 0) {
    Warn "dev 브랜치가 이미 존재합니다. 기존 브랜치를 사용합니다."
    git checkout dev
} else {
    git checkout -b dev
    Ok "dev 브랜치 생성 완료"
}

# 3. dev 브랜치를 원격에 푸시
Info "`n[3/5] dev 브랜치 원격 푸시..."
git push -u origin dev
if ($LASTEXITCODE -eq 0) { Ok "origin/dev 생성 완료" } else { Warn "원격 푸시 실패" }

# 4. 스크립트 폴더 커밋
Info "`n[4/5] scripts/ 폴더 커밋..."
git add scripts/
git commit -m "chore: scripts/deploy + scripts/dev 폴더 구조 추가" 2>&1 | Out-Null
git push origin dev

# 5. 완료 메시지
Ok "`n=========================================="
Ok "  초기 설정 완료!"
Ok ""
Ok "  브랜치 구조:"
Ok "  master → Netlify 라이브 배포"
Ok "  dev    → 개발/테스트 환경"
Ok ""
Ok "  앞으로 개발 흐름:"
Ok "  1. [데브]-dev-push.ps1 로 dev에 저장"
Ok "  2. 테스트 완료 후"
Ok "  3. [배포]-dev-to-master-merge.ps1 로 라이브 배포"
Ok "=========================================="

Read-Host "`n엔터를 누르면 창이 닫힙니다"
