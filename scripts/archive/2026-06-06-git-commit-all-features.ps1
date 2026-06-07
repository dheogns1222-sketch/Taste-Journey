# Taste Journey - 전체 기능 커밋 스크립트
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

git commit -m "feat: 역할별 아이콘 고정 + 지도 핀 인터랙션 개선

[프로필 아이콘 역할 제한]
- OWNER: 🐶 고정 (변경 불가)
- PARTNER: 🐻 고정 (변경 불가)
- GUEST: 음식 이모티콘 12종 선택 가능 (🐶🐻 제외)
- OWNER/PARTNER 편집 버튼 숨김
- openAvatarPicker/setAvatarEmoji/handleAvatarFile/resetAvatar 역할 가드 추가

[지도 핀 인터랙션]
- 핀 위에 마우스 올리면 pointer 커서로 변경 (hitTestPin 활용)
- 드래그와 클릭 구분: _dragDist > 6px 이동 시 클릭 무시
- 터치 후 합성 클릭 방지: _lastTouchTime 500ms 가드
- hitTestPin 감지 반경 14→18px 확대

[핀 미니 팝업]
- 핀 클릭 시 핀 바로 위에 미니 카드 팝업 표시
- 팝업 내용: 썸네일, 가게명, 타입(방문완료/방문예정), 평점, 매운맛, 주소
- 화면 상단 근접 시 핀 아래로 뒤집힘 (flipBelow)
- 삼각형 캐럿으로 핀 위치 지시
- panSTART 시 자동 닫힘

[상세보기 카드 이동]
- 팝업 '상세보기 →' 버튼: 목록 탭 전환 + 해당 카드 스크롤 + 하이라이트
- .card-selected CSS: 2.5px solid var(--pr) 아웃라인 2.2초 표시
- cardHTML에 id='card-\${p.id}' 추가"

git push origin feature/app-core

Write-Host ""
Write-Host "완료! GitHub에 push되었습니다." -ForegroundColor Green
Read-Host "엔터를 누르면 창이 닫힙니다"
