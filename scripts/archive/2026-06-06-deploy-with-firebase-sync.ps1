# Taste Journey - Firebase 동기화 + GitHub Pages 배포
# 실행: PowerShell에서 이 파일 우클릭 → "PowerShell로 실행"

Set-Location "D:\Clode\Projects\Taste Journey"

# index.lock 삭제
$lock = ".git\index.lock"
if (Test-Path $lock) {
    Remove-Item $lock -Force
    Write-Host "index.lock 삭제 완료"
}

Write-Host "=== STEP 1: feature/app-core 커밋 ===" -ForegroundColor Cyan
git checkout feature/app-core
git add src/index.html docs/index.html
git commit -m "feat: Firebase Realtime DB 크로스 디바이스 동기화

- 로그인 화면 하단 '연동 코드' 입력창 추가
- Firebase Realtime Database REST API 연동 (SDK 없음)
- saveUsers/savePlaces 호출 시 자동 push
- 앱 시작 시 Firebase에서 최신 데이터 pull
- 30초마다 자동 polling (다른 기기 변경사항 반영)
- 동기화 상태 인디케이터 (우상단 토스트)
- 연동 코드 한 번 입력하면 localStorage에 기억
- 기존 localStorage 캐시 방식 유지 (오프라인 지원)"

git push origin feature/app-core

Write-Host ""
Write-Host "=== STEP 2: master 병합 + push ===" -ForegroundColor Cyan
git checkout master
git merge feature/app-core --no-ff -m "merge: Firebase 동기화 기능 배포"
git push origin master

Write-Host ""
Write-Host "=== 완료! ===" -ForegroundColor Green
Write-Host ""
Write-Host "GitHub Pages URL:" -ForegroundColor Yellow
Write-Host "https://dheogns1222-sketch.github.io/Taste-Journey/" -ForegroundColor White
Write-Host ""
Read-Host "엔터를 누르면 창이 닫힙니다"
