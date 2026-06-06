# ================================================================
# Taste Journey — [데브] 개발 브랜치 푸시
# dev 브랜치에서 개발 내용 저장 (라이브에 영향 없음)
# 실행: 이 파일 우클릭 → "PowerShell로 실행"
# ================================================================

$ROOT = "D:\Clode\Projects\Taste Journey"
Set-Location $ROOT

function Info  { param($m) Write-Host $m -ForegroundColor Cyan }
function Ok    { param($m) Write-Host $m -ForegroundColor Green }
function Warn  { param($m) Write-Host $m -ForegroundColor Yellow }
function Fail  { param($m) Write-Host $m -ForegroundColor Red }

Info "=========================================="
Info "  Taste Journey  |  [데브] 개발 브랜치 저장"
Info "=========================================="

$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force; Warn "index.lock 제거" }

# dev 브랜치 확인/전환
$current = (git rev-parse --abbrev-ref HEAD 2>&1)
Info "현재 브랜치: $current"

if ($current -ne "dev") {
    Warn "dev 브랜치로 전환합니다..."
    # dev 브랜치가 없으면 생성
    $devExists = git show-ref --verify --quiet refs/heads/dev; $devOk = $LASTEXITCODE
    if ($devOk -ne 0) {
        Info "dev 브랜치 생성 중..."
        git checkout -b dev
    } else {
        git checkout dev
    }
    if ($LASTEXITCODE -ne 0) { Fail "dev 브랜치 전환 실패"; Read-Host; exit 1 }
}

# 변경사항 확인
$status = git status --short
if (-not $status) {
    Ok "변경된 파일이 없습니다."
    Read-Host "엔터를 누르면 창이 닫힙니다"
    exit 0
}

Info "`n변경된 파일:"
git status --short

# 커밋 메시지
Write-Host ""
$msg = Read-Host "커밋 메시지를 입력하세요 (엔터 = 기본값)"
if (-not $msg.Trim()) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm"
    $msg = "dev: 개발 저장 $date"
}

# 스테이징 & 커밋
git add src/index.html docs/index.html
git commit -m $msg

if ($LASTEXITCODE -ne 0) { Fail "커밋 실패"; Read-Host; exit 1 }

# dev 원격 푸시
Info "`ndev → origin 푸시 중..."
git push origin dev

if ($LASTEXITCODE -eq 0) {
    Ok "`n=========================================="
    Ok "  dev 브랜치 저장 완료!"
    Ok "  ※ 라이브에는 영향 없음"
    Ok "  테스트 완료 후 [배포]-dev-to-master-merge.ps1 실행"
    Ok "=========================================="
} else {
    Fail "푸시 실패."
}

Read-Host "`n엔터를 누르면 창이 닫힙니다"
