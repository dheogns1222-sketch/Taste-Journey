# Taste Journey - 최종 배포 (카카오 API 설정 + 권한 시스템)
# 실행: PowerShell에서 이 파일 우클릭 → "PowerShell로 실행"

Set-Location "D:\Clode\Projects\Taste Journey"

$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force; Write-Host "index.lock 삭제 완료" }

Write-Host "=== 변경사항 커밋 + master push ===" -ForegroundColor Cyan
git checkout master
git add src/index.html docs/index.html
git commit -m "feat: 카카오 API 설정 + 권한 시스템 + 버그 수정 전면 배포

[카카오 API]
- 프로필 탭 OWNER 전용 카카오 API 설정 섹션 추가
- REST API Key (음식점 검색), JS Key (카카오맵) 입력/저장
- JS 키 저장 후 새로고침 확인 팝업

[권한 시스템]
- 어드민(gpgr) 자동 생성 (OWNER)
- 초대코드 2종: 파트너용(OWNER만), 게스트용(OWNER/PARTNER)
- GUEST: 조회/공유/댓글만, 추가/수정/삭제 불가

[버그 수정]
- 수정 패널 미열림: addr-panel null 오류 제거
- 추가 불가: 주소 필수 체크 완화
- 검색 결과 1개: name-drop 스크롤 CSS 수정
- 범례 검색창 가림: 범례 인라인 이동"

git push origin master

Write-Host ""
Write-Host "=== 완료! Netlify 자동 배포 중 ===" -ForegroundColor Green
Write-Host "1~2분 후 https://prismatic-marzipan-0081c6.netlify.app 확인" -ForegroundColor Yellow
Write-Host ""
Read-Host "엔터를 누르면 창이 닫힙니다"
