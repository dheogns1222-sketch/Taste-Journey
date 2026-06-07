# Taste Journey - Bug Fix Commit Script
# 실행: PowerShell에서 이 파일 우클릭 → "PowerShell로 실행"

Set-Location "D:\Clode\Projects\Taste Journey"

# index.lock 삭제
$lock = ".git\index.lock"
if (Test-Path $lock) {
    Remove-Item $lock -Force
    Write-Host "index.lock 삭제 완료"
}

# Git commit & push
git add src/index.html
git commit -m "fix: 3개 버그 수정 (공유팝업 z-index, 대표사진선택, 지도핀탭)

- fix(share): modal-share z-index:200 으로 modal-detail 위에 노출
- feat(photo): 대표사진 선택 UI (썸네일 클릭, 강조 테두리)
  mainPhotoIdx 상태+setMainPhoto 함수, doSave/openEditModal/shareAsCard 연동
- fix(map): 지도 핀 탭 무반응 수정
  touchend 이동거리 10px 임계값, click 터치후 500ms 가드, hitTestPin mapFilter 적용"

git push origin feature/app-core

Write-Host ""
Write-Host "완료! GitHub에 push되었습니다." -ForegroundColor Green
Read-Host "엔터를 누르면 창이 닫힙니다"
