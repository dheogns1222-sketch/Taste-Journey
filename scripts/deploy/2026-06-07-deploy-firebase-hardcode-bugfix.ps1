# ================================================================
# Taste Journey — Firebase 하드코딩 + 버그 4개 수정 배포
# 실행: 이 파일 우클릭 → "PowerShell로 실행"
# ================================================================

$ROOT = "D:\Clode\Projects\Taste Journey"
Set-Location $ROOT

$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force }

git checkout master
git add src/index.html docs/index.html
git commit -m "fix: Firebase 하드코딩 + 초대코드/멤버 4개 버그 수정

- Firebase URL 하드코딩 (모바일/모든기기 자동 연동)
- 로그인 페이지 연동코드 입력 UI 제거
- useInviteCode() usedBy null 버그 수정 (사용자 표시 정상화)
- deleteUser() 초대코드 cleanup 추가
- pull()에 invite_codes 복원 추가"

git push origin master

Write-Host "완료! 1~2분 후 https://prismatic-marzipan-0081c6.netlify.app 새로고침" -ForegroundColor Green
Read-Host "엔터를 누르면 창이 닫힙니다"
