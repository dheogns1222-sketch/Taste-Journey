# Taste Journey - 카카오 네이티브 검색 배포
# 실행: PowerShell에서 이 파일 우클릭 → "PowerShell로 실행"

Set-Location "D:\Clode\Projects\Taste Journey"

$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force }

git checkout master
git add src/index.html docs/index.html
git commit -m "feat: 카카오 네이티브 검색 연동

- Kakao Maps SDK에 &libraries=services 추가
- 맛집 추가 검색: Kakao Places SDK 1순위 (카카오맵과 동일)
- 맛집 추가 검색: Kakao REST API 2순위 (카테고리 필터 제거)
- 맛집 추가 검색: Nominatim 3순위 폴백
- 지도 상단 검색: Kakao Places SDK + Geocoder 사용
- 검색 결과에 카테고리/전화번호 표시 추가"

git push origin master

Write-Host "완료! 1~2분 후 https://prismatic-marzipan-0081c6.netlify.app 새로고침" -ForegroundColor Green
Read-Host "엔터를 누르면 창이 닫힙니다"
