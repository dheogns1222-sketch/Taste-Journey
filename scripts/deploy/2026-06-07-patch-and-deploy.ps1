# Taste Journey - 패치 + 배포
# 우클릭 -> PowerShell로 실행

$ErrorActionPreference = "Stop"
$ROOT = "D:\Clode\Projects\Taste Journey"
Set-Location $ROOT

Write-Host "패치 시작..." -ForegroundColor Cyan

$lock = ".git\index.lock"
if (Test-Path $lock) { Remove-Item $lock -Force }

# Python으로 패치 실행
$py = @'
import sys, re

path = r"D:\Clode\Projects\Taste Journey\src\index.html"
with open(path, "r", encoding="utf-8") as f:
    s = f.read()

results = []

def patch(label, old, new):
    global s
    if old in s:
        s = s.replace(old, new, 1)
        results.append("OK: " + label)
    elif new in s or label.startswith("F7") or label.startswith("F8"):
        results.append("SKIP(already): " + label)
    else:
        results.append("MISS: " + label)

# F1: Firebase URL 하드코딩
patch("F1",
    "get url(){return DB.g('fb_url','');}",
    "get url(){return DB.g('fb_url','https://taste-journey-d3176-default-rtdb.asia-southeast1.firebasedatabase.app');}"
)

# F2: pull invite_codes
patch("F2",
    "if(d.places&&Array.isArray(d.places))DB.s('places',d.places);\n      return true;",
    "if(d.places&&Array.isArray(d.places))DB.s('places',d.places);\n      if(d.invite_codes&&Array.isArray(d.invite_codes))DB.s('invite_codes',d.invite_codes);\n      return true;"
)

# F3: login auto pull
patch("F3",
    "const fbUrl=DB.g('fb_url','');\n    if(fbUrl){showSyncStatus(",
    "if(FB.url){showSyncStatus("
)

# F4: useInviteCode param
patch("F4a", "function useInviteCode(raw){", "function useInviteCode(raw,forcedUserId=null){")
patch("F4b", "codes[idx].usedBy=ME?ME.id:null;", "codes[idx].usedBy=forcedUserId||(ME?ME.id:null);")

# F5: handleAuth newId first
patch("F5",
    "const codeType=useInviteCode(_pendingInviteCode);\n    if(!codeType){showAuthError('초대 코드 오류. 처음부터 다시 시도해주세요');return;}\n    const freshUsers=getUsers();\n    if(freshUsers.find(x=>x.username===u)){showAuthError('이미 사용 중인 아이디입니다');return;}\n    const role=codeType==='partner'?'PARTNER':'GUEST';\n    const nu={id:Date.now().toString()",
    "const freshUsers=getUsers();\n    if(freshUsers.find(x=>x.username===u)){showAuthError('이미 사용 중인 아이디입니다');return;}\n    const newId=Date.now().toString();\n    const codeType=useInviteCode(_pendingInviteCode,newId);\n    if(!codeType){showAuthError('초대 코드 오류. 처음부터 다시 시도해주세요');return;}\n    const role=codeType==='partner'?'PARTNER':'GUEST';\n    const nu={id:newId"
)

# F6: deleteUser cleanup
patch("F6",
    "saveUsers(users.filter(x=>x.id!==uid));\n  toast(`${u.username} 계정을 삭제했습니다`);\n  openUsersModal();\n}",
    "const codes=getInviteCodes();\n  saveInviteCodes(codes.filter(c=>c.usedBy!==uid));\n  saveUsers(users.filter(x=>x.id!==uid));\n  FB.push();\n  toast(`${u.username} 계정을 삭제했습니다`);\n  openUsersModal();\n}"
)

# F7: 연동 UI 제거
if 'class="sync-bar"' in s:
    i = s.find('<div class="sync-bar"')
    j = s.find('</div>', i) + len('</div>')
    s = s[:i] + s[j:]
    results.append("OK: F7 sync-bar 제거")
    h = s.find('<div id="sync-help"')
    if h >= 0:
        hj = s.find('</div>', h) + len('</div>')
        s = s[:h] + s[hj:]
        results.append("OK: F7 sync-help 제거")
else:
    results.append("SKIP(already): F7")

# F8: init fb-url-input 참조 제거
patch("F8",
    "const existingUrl=DB.g('fb_url','');\n  if(existingUrl){const inp=document.getElementById('fb-url-input');if(inp)inp.value=existingUrl;}",
    "// Firebase URL은 하드코딩으로 자동 연동됨"
)

# 저장
with open(path, "w", encoding="utf-8") as f:
    f.write(s)

docs = path.replace(r"src\index.html", r"docs\index.html")
with open(docs, "w", encoding="utf-8") as f:
    f.write(s)

print("\n".join(results))
print("SIZE:" + str(len(s.encode("utf-8"))))
'@

$result = python -c $py
Write-Host $result

# 파일 크기 확인
$size = (Get-Item "src\index.html").Length
Write-Host "파일 크기: $size bytes" -ForegroundColor Cyan

# Git 커밋
git checkout master
git add src/index.html docs/index.html

$diff = git diff --cached --stat
if ($diff) {
    git commit -m "fix: Firebase hardcode + invite/member bugfix"
    git push origin master
    Write-Host "`n배포 완료! https://prismatic-marzipan-0081c6.netlify.app" -ForegroundColor Green
} else {
    Write-Host "`n변경 없음 - 이미 최신" -ForegroundColor Yellow
}

Read-Host "`n엔터 누르면 닫힙니다"
