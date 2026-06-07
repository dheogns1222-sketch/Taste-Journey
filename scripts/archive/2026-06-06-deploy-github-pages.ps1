# Taste Journey - GitHub Pages 배포 스크립트
# 실행: PowerShell에서 이 파일 우클릭 → "PowerShell로 실행"

Set-Location "D:\Clode\Projects\Taste Journey"

# index.lock 삭제
$lock = ".git\index.lock"
if (Test-Path $lock) {
    Remove-Item $lock -Force
    Write-Host "index.lock 삭제 완료"
}

Write-Host "=== STEP 1: feature/app-core 브랜치 커밋 ===" -ForegroundColor Cyan
git checkout feature/app-core
git add src/index.html docs/index.html
git commit -m "feat: GitHub Pages 배포용 docs/index.html 추가

- docs/index.html = src/index.html 동일 파일
- GitHub Pages (master/docs) 배포를 위해 추가"

git push origin feature/app-core

Write-Host ""
Write-Host "=== STEP 2: master 브랜치에 병합 ===" -ForegroundColor Cyan
git checkout master
git merge feature/app-core --no-ff -m "merge: feature/app-core → master (GitHub Pages 배포)"
git push origin master

Write-Host ""
Write-Host "=== 완료! ===" -ForegroundColor Green
Write-Host ""
Write-Host "이제 GitHub에서 Pages를 활성화하세요:" -ForegroundColor Yellow
Write-Host "1. https://github.com/dheogns1222-sketch/Taste-Journey/settings/pages 접속"
Write-Host "2. Source: 'Deploy from a branch' 선택"
Write-Host "3. Branch: master / 폴더: /docs 선택"
Write-Host "4. Save 클릭"
Write-Host ""
Write-Host "약 1~2분 후 아래 URL에서 접속 가능:" -ForegroundColor Green
Write-Host "https://dheogns1222-sketch.github.io/Taste-Journey/" -ForegroundColor White
Write-Host ""
Read-Host "엔터를 누르면 창이 닫힙니다"
