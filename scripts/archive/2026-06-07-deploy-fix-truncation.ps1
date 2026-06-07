# Taste Journey - 파일 잘림 수정 배포
# 실행: PowerShell에서 이 파일 우클릭 → "PowerShell로 실행"

Set-Location "D:\Clode\Projects\Taste Journey"

$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force }

git checkout master
git add src/index.html docs/index.html
git commit -m "fix: 파일 잘림 수정 - 로그인 정상화

- 137572바이트 잘림 문제 해결
- toast(), startApp(), updateHeader(), initPWA() 복구
- init IIFE 및 이벤트 리스너 복구
- Kakao Places SDK 네이티브 검색 유지"

git push origin master

Write-Host "완료! 1~2분 후 https://prismatic-marzipan-0081c6.netlify.app 새로고침" -ForegroundColor Green
Read-Host "엔터를 누르면 창이 닫힙니다"
