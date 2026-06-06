# ================================================================
# Taste Journey — [배포] 라이브 배포 스크립트
# master 브랜치 → Netlify 자동 배포
# 실행: 이 파일 우클릭 → "PowerShell로 실행"
# ================================================================

$ROOT = "D:\Clode\Projects\Taste Journey"
Set-Location $ROOT

# 색상 헬퍼
function Info  { param($m) Write-Host $m -ForegroundColor Cyan }
function Ok    { param($m) Write-Host $m -ForegroundColor Green }
function Warn  { param($m) Write-Host $m -ForegroundColor Yellow }
function Fail  { param($m) Write-Host $m -ForegroundColor Red }

Info "=========================================="
Info "  Taste Journey  |  [배포] 라이브 배포"
Info "=========================================="

# 잠금 파일 정리
$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force; Warn "index.lock 제거 완료" }

# 현재 브랜치 확인
$current = (git rev-parse --abbrev-ref HEAD 2>&1)
Info "현재 브랜치: $current"

if ($current -ne "master") {
    Warn "master 브랜치가 아닙니다. master로 전환합니다..."
    git checkout master
    if ($LASTEXITCODE -ne 0) { Fail "master 전환 실패. 중단합니다."; Read-Host; exit 1 }
}

# 변경된 파일 확인
$status = git status --short
if (-not $status) {
    Ok "변경된 파일이 없습니다. 배포할 내용이 없습니다."
    Read-Host "엔터를 누르면 창이 닫힙니다"
    exit 0
}

Info "`n변경된 파일:"
git status --short

# 커밋 메시지 입력
Write-Host ""
$msg = Read-Host "커밋 메시지를 입력하세요 (엔터 = 기본값 사용)"
if (-not $msg.Trim()) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm"
    $msg = "deploy: 라이브 배포 $date"
}

# 스테이징 & 커밋
git add src/index.html docs/index.html
git commit -m $msg

if ($LASTEXITCODE -ne 0) {
    Fail "커밋 실패. 중단합니다."
    Read-Host
    exit 1
}

# master 푸시
Info "`nmaster → origin 푸시 중..."
git push origin master

if ($LASTEXITCODE -eq 0) {
    Ok "`n=========================================="
    Ok "  배포 완료!"
    Ok "  Netlify: https://prismatic-marzipan-0081c6.netlify.app"
    Ok "  (1~2분 후 반영됩니다)"
    Ok "=========================================="
} else {
    Fail "푸시 실패. 네트워크 또는 권한을 확인하세요."
}

Read-Host "`n엔터를 누르면 창이 닫힙니다"
