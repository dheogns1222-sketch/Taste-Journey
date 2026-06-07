# Taste Journey - Avatar Role Fix Commit
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
git commit -m "feat(profile): 역할별 프로필 아이콘 고정 및 선택 제한

- OWNER: 🐶 고정 (변경 불가)
- PARTNER: 🐻 고정 (변경 불가)
- GUEST: 음식 이모티콘 12종 선택 가능 (🐶🐻 제외)
- OWNER/PARTNER 아이콘 편집 버튼 숨김
- openAvatarPicker/setAvatarEmoji/handleAvatarFile/resetAvatar 역할 가드 추가"

git push origin feature/app-core

Write-Host ""
Write-Host "완료! GitHub에 push되었습니다." -ForegroundColor Green
Read-Host "엔터를 누르면 창이 닫힙니다"
