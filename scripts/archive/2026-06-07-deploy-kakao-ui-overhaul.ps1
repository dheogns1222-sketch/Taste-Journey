# Taste Journey - 카카오맵 + UI 개편 배포 스크립트
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
git commit -m "feat: 카카오맵 연동 + UI 전면 개편

[카카오맵 연동]
- 로그인 화면에 카카오 REST API Key / JS App Key 입력창 추가
- JS App Key 설정 시 OSM 캔버스 대신 카카오맵 SDK 로드
- 카카오맵 마커: 방문완료(빨강) / 방문예정(파랑) SVG 핀
- MAP 객체 _useKakao 플래그 기반 이중 렌더 구조
- zoomIn/Out, geoLocate, panTo, pinScreenPos 카카오 분기 처리

[음식점 이름 검색 개선]
- 카카오 Local REST API 검색 (FD6/CE7 카테고리, 15건)
- 키 없을 시 Nominatim 폴백
- 검색 결과: 상호명 + 도로명 주소 드롭다운
- 주소 입력란 단순화 (f-addr-q 제거, 이름 검색 시 자동 입력)
- 상세 주소 입력란 유지

[별점/맵기 UI 버그 수정]
- starsHTML(): 5점 기준 반별(½) 표시, 비활성 ☆ 별 정상 출력
- spiceHTML(): 비활성 고추 grayscale+opacity:0.5 (흰색 소거)
- 카드/상세/공유 캔버스 전체 /10→/5 수정
- 맵기 아이콘 카드에서 별점 아래 별도 행으로 이동

[수정 패널 버그 수정]
- openEditModal: f-menu, f-addr-q 참조 제거
- openAddModal 리셋: f-addr-q 제거
- doReset: 불필요한 필드 정리"

git push origin feature/app-core

Write-Host ""
Write-Host "=== STEP 2: master 병합 + push ===" -ForegroundColor Cyan
git checkout master
git merge feature/app-core --no-ff -m "merge: 카카오맵 + UI 개편 배포"
git push origin master

Write-Host ""
Write-Host "=== 완료! ===" -ForegroundColor Green
Write-Host ""
Write-Host "GitHub Pages URL:" -ForegroundColor Yellow
Write-Host "https://dheogns1222-sketch.github.io/Taste-Journey/" -ForegroundColor White
Write-Host ""
Write-Host "[카카오 키 설정 방법]" -ForegroundColor Yellow
Write-Host "1. https://developers.kakao.com 접속 → 내 애플리케이션"
Write-Host "2. REST API 키 → 앱 로그인 화면 카카오 REST API Key 입력란에 붙여넣기"
Write-Host "3. JavaScript 키 → 카카오 JS App Key 입력란에 붙여넣기"
Write-Host "4. JS 키 설정 시 플랫폼 → Web → 사이트 도메인에 배포 URL 등록 필요"
Write-Host "   예) https://dheogns1222-sketch.github.io"
Write-Host ""
Read-Host "엔터를 누르면 창이 닫힙니다"
