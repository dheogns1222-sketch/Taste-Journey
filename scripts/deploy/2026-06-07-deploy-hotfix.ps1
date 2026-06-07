# Taste Journey - 핫픽스 배포
# 우클릭 -> PowerShell로 실행

Set-Location "D:\Clode\Projects\Taste Journey"

$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force }

git checkout master
git add src/index.html docs/index.html
git status --short

$diff = git diff --cached --name-only
if ($diff) {
    git commit -m "fix: 헤더 중복/코드 정리/Firebase pull 개선"
    git push origin master
    Write-Host "배포 완료! https://prismatic-marzipan-0081c6.netlify.app" -ForegroundColor Green
} else {
    Write-Host "변경사항 없음 - 이미 최신입니다" -ForegroundColor Yellow
}

Read-Host "엔터 누르면 닫힙니다"
