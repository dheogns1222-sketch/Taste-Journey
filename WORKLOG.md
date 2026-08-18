# WORKLOG — [개발] Taste Journey

최신이 위. 아키텍처·절대 규칙·배포 절차는 CLAUDE.md, 축적 지식은 두뇌 위키 `projects/프로젝트_Taste_Journey.md`.

## 2026-08-18 — 인수인계·보안 헤더 배포·배포 스크립트 정리 (Fable 5 세션)
- 폴더명 `Taste Journey` → `[개발] Taste Journey`. 배포 스크립트 D:→F: 경로 치환.
- **보안 헤더 라이브 배포**: CSP·HSTS·nosniff·X-Frame-Options DENY·Referrer-Policy·Permissions-Policy. CSP는 카카오 공지대로 `*.kakaocdn.net`·`*.daumcdn.net` 포함(없으면 카카오맵 SDK 차단→OSM 폴백). 로컬 검증 `scripts/dev/serve-with-headers.py`(`.claude/launch.json` `taste-journey`, :8123)로 CSP 위반 0건 확인.
- **실측: Vercel Root Directory = `docs`** → 설정 정본은 `docs/vercel.json`. 루트 vercel.json은 읽히지 않아 제거(92d6ae5). Vercel 확정 근거는 `gh api repos/dheogns1222-sketch/Taste-Journey/deployments`의 Production 환경.
- **배포 스크립트 지뢰 제거**: `[배포]-dev-to-master-merge.ps1`이 폐기된 `src/index.html`(6월 구버전)을 `docs/`에 덮어써 라이브를 롤백시키던 구조 → 삭제. 4개 스크립트 스테이징 `git add docs`, push `origin master` + `origin master:main`. `src/` git 삭제, 잔재(`src/manifest.json`·`docs/index.html.bak`·`*.ps1.bak4`)는 `99_ARCHIVE\Taste-Journey_구버전잔재_2026-08-18`로 이동.
- 앱 코드 무변경 — 라이브 `APP_VER 2.0.1`, sw `tj-v7` 유지. 커밋 83a0c83 → 0ff9c33 → 3f393f5 → 1ddf05c → 92d6ae5.
- **사장 지시: 재개 전까지 대기.** 재개 시 첫 확인: 사장 폰에서 지도 탭 열어 카카오맵 정상 표시 여부(CSP `unsafe-eval` 미필요 확정; 실패 시 자동 OSM 폴백이라 치명 아님).
- 백로그(우선순위 미확정): ① Firebase Auth 도입(유저 단위 규칙, 수익화 전제) ② 수익화(AdSense/TWA+AdMob/구독) ③ 개인화 추천 ④ Firestore 전환 보류.

## 2026-07-20 — 배포 게이트 재검증 (배포검증부)
- 5종 전부 PASS: 버전 3곳 일치(2.0.1 / tj-v7) · JS 문법 · 라이브 200 · PWA 자산 6종 · RTDB REST `?auth` 전수 첨부.

## 2026-07-14~15 — 레시피 북 + 메종 에디션 + 업데이트 배너 (v2.0.0 → v2.0.1)
- 레시피 카드북 탭: JPG 33장 → `docs/recipes/data.json`, 앱 내 등록/수정/삭제(OWNER/PARTNER), RTDB `recipes` 키 커플 동기화, 검색·즐겨찾기·원본 뷰어. sw.js cache-first 저장 버그 수정.
- 메종 에디션 전면 리디자인(Cormorant Garamond+Noto Serif KR, SVG 아이콘, 앱 아이콘 크레스트 `maison-*` 캐시버스팅).
- 인앱 업데이트 배너(`APP_VER` vs `version.json`), 로그인 화면 "데이터 연동 설정" 탭(Firebase Secret으로 어드민 복구 경로), 앱 버전 표시.
- Firebase 규칙 `.read/.write: false` 완전 잠금 — 앱은 Secret 기반 통신이라 정상. 잠금 후 지연 스캔 경고 메일 1~2건 정상.

## 2026-06-05~08 — v1 (D:\Clode\Projects\Taste Journey)
- 단일 HTML PWA 골격, 카카오맵/OSM 폴백, Firebase RTDB 동기화(SSE+폴링), 권한 3단계, 공유카드 Canvas, 럭셔리 디자인. 배포처 Vercel(정식)·Netlify·GH Pages(여분).
