# 배포 전 게이트 — 실행: python scripts/dev/check-release.py  (전부 PASS 여야 push)
#  1) APP_VER == docs/version.json.ver   2) sw.js CACHE 존재·형식
#  3) 마지막 <script> 블록 JS 문법(node)   4) index.html/sw.js 의 외부 호스트가 docs/vercel.json CSP 허용목록에 포함
import json, os, re, subprocess, sys
sys.stdout.reconfigure(encoding='utf-8')  # Windows cp949 콘솔 대응
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
D = lambda *p: os.path.join(ROOT, 'docs', *p)
html = open(D('index.html'), encoding='utf-8').read()
sw = open(D('sw.js'), encoding='utf-8').read()
fails = []
def check(name, ok, detail=''):
    print(('PASS ' if ok else 'FAIL ') + name + (f'  — {detail}' if detail else ''))
    if not ok: fails.append(name)

# 1) 버전 동기화
app_ver = re.search(r"const APP_VER='([^']+)'", html).group(1)
json_ver = json.load(open(D('version.json'), encoding='utf-8'))['ver']
check('APP_VER == version.json', app_ver == json_ver, f'{app_ver} vs {json_ver}')
# 2) sw 캐시명
m = re.search(r"const CACHE='(tj-v\d+)'", sw)
check('sw.js CACHE 형식', bool(m), m.group(1) if m else 'not found')

# 3) JS 문법 (CLAUDE.md 의 node 검사와 동일)
js = html[html.rfind('<script') + 8:html.rfind('</script>')]  # CLAUDE.md 의 node 검사와 동일 슬라이스
try:
    r = subprocess.run(['node', '-e', 'new Function(require("fs").readFileSync(0,"utf8"));'], input=js, text=True, encoding='utf-8', capture_output=True, timeout=60)
    check('JS 문법(node)', r.returncode == 0, (r.stderr.strip().splitlines() or [''])[-1][:120])
except FileNotFoundError:
    check('JS 문법(node)', False, 'node 미설치 — 수동 검사 필요')

# 4) CSP 허용목록 커버리지 (정적, 보수적) — 스킴 있는 https:// 호스트만 검사
csp = next(h['value'] for rule in json.load(open(D('vercel.json'), encoding='utf-8'))['headers'] for h in rule['headers'] if h['key'] == 'Content-Security-Policy')
directives = {}
for part in csp.split(';'):
    toks = part.split()
    if toks: directives[toks[0]] = toks[1:]
def allowed(host, directive):
    srcs = directives.get(directive) or directives.get('default-src', [])
    for s in srcs:
        s = s.replace('https://', '')
        if s == 'https:' or s == host: return True
        if s.startswith('*.') and host.endswith(s[1:]): return True
    return False
hosts = sorted(set(re.findall(r'https://([A-Za-z0-9.\-]+)', html + sw)) - {'www.w3.org'})
# 용도 추정: 스크립트/폰트/CSS 로 명시된 것 외에는 connect 또는 img 로 간주 → connect-src 또는 img-src 어느 하나에 허용되면 통과
script_hosts = set(re.findall(r'<script[^>]+src="https://([^/"]+)', html)) | set(re.findall(r"s\.src='//([^/']+)", html))
style_hosts = set(re.findall(r"@import url\('https://([^/']+)", html))
font_hosts = set(re.findall(r"url\(https://([^/)]+)/[^)]*\.woff2?\)", html))
for h in hosts:
    if h in script_hosts:  check(f'CSP script-src ⊇ {h}', allowed(h, 'script-src'))
    elif h in style_hosts: check(f'CSP style-src ⊇ {h}', allowed(h, 'style-src'))
    elif h in font_hosts:  check(f'CSP font-src ⊇ {h}', allowed(h, 'font-src'))
    else:                  check(f'CSP connect|img-src ⊇ {h}', allowed(h, 'connect-src') or allowed(h, 'img-src'))
# 카카오맵 SDK 2차 리소스(공식 공지: *.daumcdn.net / *.kakaocdn.net)
for h in ('t1.daumcdn.net', 't1.kakaocdn.net'):
    check(f'CSP script-src ⊇ {h} (카카오맵 SDK)', allowed(h, 'script-src'))

print('\n' + ('ALL PASS' if not fails else f'{len(fails)} FAIL: ' + ', '.join(fails)))
sys.exit(1 if fails else 0)
