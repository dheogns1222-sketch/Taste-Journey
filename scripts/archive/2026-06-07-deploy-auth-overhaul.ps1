# Taste Journey - 계정/권한 시스템 개편 배포
# 실행: PowerShell에서 이 파일 우클릭 → "PowerShell로 실행"

Set-Location "D:\Clode\Projects\Taste Journey"

$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force; Write-Host "index.lock 삭제 완료" }

Write-Host "=== STEP 1: feature/app-core 커밋 ===" -ForegroundColor Cyan
git checkout feature/app-core
git add src/index.html docs/index.html
git commit -m "feat: 계정/권한 시스템 전면 개편 + 버그 수정

[계정 시스템]
- 어드민 계정(gpgr) 앱 최초 실행 시 자동 생성 (하드코딩 없음, 해시 저장)
- 초대코드 2종: 파트너용(OWNER만), 게스트용(OWNER/PARTNER)
- 회원가입 시 초대코드 필수 입력 → 역할 자동 배정
- 초대코드 Firebase 동기화 (다기기 공유)

[권한 분리]
- OWNER/PARTNER: 맛집 추가/수정/삭제 가능
- GUEST: 조회·공유·댓글·아바타 변경만 가능
- + 버튼: 게스트에겐 비허용 토스트 안내

[카카오 API]
- 로그인 화면에서 카카오 키 입력란 제거
- 프로필 탭 내 OWNER 전용 카카오 API 설정 섹션으로 이동
- JS 키 저장 시 새로고침 확인 팝업

[버그 수정]
- 수정 패널 미열림: addr-panel null 참조 오류 제거
- 추가 불가: 주소 필수 체크 완화 (경고 없이 저장 허용)
- 검색 결과 1개만 표시: name-drop 스크롤 CSS 수정
- 범례 검색창 가림: 범례를 필터바 인라인으로 이동"

git push origin feature/app-core

Write-Host ""
Write-Host "=== STEP 2: master 병합 ===" -ForegroundColor Cyan
git checkout master
git merge feature/app-core --no-ff -m "merge: 계정/권한 시스템 개편 배포"
git push origin master

Write-Host ""
Write-Host "=== 완료! ===" -ForegroundColor Green
Write-Host ""
Write-Host "다음 단계: Netlify 배포 (저장소를 Private으로 전환 후)" -ForegroundColor Yellow
Write-Host "1. https://github.com/dheogns1222-sketch/Taste-Journey → Settings → Danger Zone → Change visibility → Private"
Write-Host "2. https://app.netlify.com → Add new site → Import an existing project → GitHub"
Write-Host "3. 저장소 선택 → Publish directory: docs → Deploy"
Write-Host ""
Read-Host "엔터를 누르면 창이 닫힙니다"
