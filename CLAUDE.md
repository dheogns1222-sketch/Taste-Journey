# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

커플용 맛집 투어 기록 PWA. 빌드 도구 없이 **단일 HTML 파일**(`docs/index.html`)로 모든 기능을 구현한다. Vercel이 `docs/` 폴더를 서빙한다 (`vercel.json` → `outputDirectory: docs`).

## 배포

```bash
# 커밋 후 main 브랜치로 push → Vercel 자동 배포
git add docs/index.html docs/sw.js
git commit -m "fix: 설명"
git push origin master:main
```

**배포 전 버전 3곳을 반드시 함께 올린다** (인앱 업데이트 배너가 이 버전을 비교):

1. `docs/index.html` — `const APP_VER='X.Y.Z'`
2. `docs/version.json` — `{"ver":"X.Y.Z","note":"업데이트 요약(배너에 표시)"}`
3. `docs/sw.js` — `const CACHE='tj-vN'` (에셋 변경 시)

APP_VER ≠ version.json이면 기존 사용자에게 상단 업데이트 배너가 뜨고, 탭하면 캐시 전체 삭제 후 새로고침된다.

- **로컬 브랜치**: `master` → **원격 브랜치**: `main` (Vercel이 `main` 감시)
- `.git/index.lock` 충돌 시 PC에서 수동 삭제 후 push (`sandbox에서 rm 불가`)
- PowerShell 배포 스크립트: `scripts/deploy/[배포]-master-push.ps1`

## 파일 수정 패턴

`docs/index.html`은 4000줄 이상이므로 항상 Python 문자열 치환 방식으로 수정한다:

```bash
cp docs/index.html /tmp/work.html
# Python으로 정확한 문자열 치환
python3 -c "
with open('/tmp/work.html','r',encoding='utf-8') as f: html=f.read()
html=html.replace('OLD','NEW',1)
with open('/tmp/work.html','w',encoding='utf-8') as f: f.write(html)
"
# JS 문법 검사
node -e "const h=require('fs').readFileSync('/tmp/work.html','utf8');const s=h.slice(h.lastIndexOf('<script')+8,h.lastIndexOf('</script>'));new Function(s);console.log('OK')"
cp /tmp/work.html docs/index.html
```

## 아키텍처 — docs/index.html

모든 CSS·HTML·JS가 한 파일에 담겨 있으며 아래 순서로 구성된다:

### 핵심 객체

| 객체 | 역할 |
|------|------|
| `DB` | localStorage CRUD (`tj2_` 접두사). `DB.g(key,def)` / `DB.s(key,val)` / `DB.d(key)` |
| `FB` | Firebase RTDB REST 동기화. `FB.push()` (300ms 디바운스 PUT), `FB.pull()` (GET), `FB.startStream()` (SSE) |
| `MAP` | 카카오맵 or Leaflet/OSM fallback 지도 렌더링 |
| `C`  | 앱 전역 상수 (카테고리 목록, 역할 레이블, 재방문 레이블) |
| `ME` | 현재 로그인 유저 객체 (`null` = 비로그인) |

### 데이터 저장소

- **localStorage** (`tj2_` prefix): `users`, `places`, `invite_codes`, `kakao_rest_key`, `kakao_js_key`, `fb_url`, `fb_secret`
- **Firebase RTDB**: `/tj.json` (메인 데이터), `/tj_bak/{YYYY-MM-DD}.json` (자동 일별 백업)
- Firebase 보안: `FB.secret`(= `fb_secret`)을 `?auth=SECRET` 쿼리로 모든 REST 호출에 첨부

### 데이터 구조

```js
// Place 객체
{ id, type:'visited'|'wish', category, name, address, addressDetail, zipNo,
  lat, lng, visitDate, rating(0-5), spiciness(0-10), revisit(0-2), priority(1-5),
  memo, photos:[base64], mainPhotoIdx, photoUrls:[string], restaurantUrl,
  createdBy(userId), createdAt(ISO), likes:[userId], comments:[Comment],
  visibility:'couple' }

// User 객체
{ id, username, passwordHash, role:'OWNER'|'PARTNER'|'GUEST',
  nickname, avatar(emoji|base64), kakaoId, kakaoNickname, kakaoProfileImage }
```

### 권한 시스템

- `OWNER`: 전체 권한 (멤버 관리, 초대코드 생성, 데이터 삭제)
- `PARTNER`: 쓰기 + 게스트 초대
- `GUEST`: 읽기 + 댓글/좋아요
- `canWrite()` = OWNER || PARTNER
- `isOwner()` / `isPartner()` 헬퍼 함수 사용

### 뷰 구조

5개 탭: `map` → `list` → `wish` → `stats` → `profile`  
`navTo(v)` → `renderView()` → 각 `render*()` 함수 호출

### 실시간 동기화 흐름

```
FB.startStream() → EventSource(/tj/pushedAt.json) → 변경 감지 → FB.pull() → renderView()
  ↳ 실패 시 FB.startPoll() (30초 폴링 fallback)
document.visibilitychange (탭 복귀) → FB.pull() → renderView()
```

### 공유카드 (Canvas)

`shareAsCard(id)` → `_buildShareCanvas()` → 4종 레이아웃(`_sc_layout*`) → Canvas → Blob  
`SHARE_FMTS` 배열에 레이아웃 메타데이터 정의

### PWA

- `docs/sw.js`: HTML 네비게이션 network-first, 정적 에셋 cache-first, 캐시 버전 `tj-v3`
- `beforeinstallprompt`: 페이지 로드 최상단에서 등록 (`startApp()` 내부 아님)

## 절대 규칙 — 유저 데이터 보호

- **코드 수정만**: `docs/index.html`, `docs/sw.js` 파일만 변경
- **QA 중 데이터 변경 금지**: `save*()`, `delete*()`, `FB.push()` 등을 브라우저 콘솔에서 직접 실행하지 않는다
- **마이그레이션**: 기존 데이터 읽기 → 병합 방식만 허용 (덮어쓰기 금지)
- Firebase 또는 localStorage의 실제 유저 데이터(장소 목록·계정·초대코드)를 임의로 건드리지 않는다

## 응답 형식

수정 관련 답변은 `(파일 경로)` — `(수정 내용 및 적용 규칙)` 형식으로 정리한다.
